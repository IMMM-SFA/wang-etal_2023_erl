;************************************************************
begin
;************************************************************
  nvar = 4
  N = 4
  clat = 224
  clon = 464
  ngrid = 5412
  
  varname = (/"(a) ~F10~SW~B~atm","(b) ~F10~SW~B~atm","(c) ~F10~Wind~B~atm","(d) ~F10~Wind~B~atm"/)
  unitname = (/" W m~S~-2"," W m~S~-2"," m s~S~-1"," m s~S~-1"/)
  seaname = (/"JJA","DJF"/)

  diri = "/Users/wly/post/"
  f = addfile(diri+"process/anth/anth.nc","r")
  var0 = f->var(0:1,:,:,12:13)

  var1 = new((/nvar,clat,clon/),float)
  var1(0:1,:,:) = var0(:,:,:,0)
  var1(2:3,:,:) = var0(:,:,:,1)

  var2 = new((/ngrid,nvar/),float)
  cnt=0
  do i=0,clat-1
    do j=0,clon-1
      if(.not.ismissing(var1(0,i,j)))then
        var2(cnt,:)=var1(:,i,j)
        cnt=cnt+1
      end if
    end do
  end do
  ;print(cnt)

  opt = True
  opt@PrintStat = False
  yval = new((/nvar,5/),"float")
  do i=0,nvar-1
    statb = stat_dispersion(var2(:,i), opt )
    yval(i,0) = statb(0)-statb(1);statb(6)-1.5*(statb(10)-statb(6));statb(2)
    yval(i,1) = statb(6)
    yval(i,2) = statb(8)
    yval(i,3) = statb(10)
    yval(i,4) = statb(0)+statb(1);statb(10)+1.5*(statb(10)-statb(6));statb(14)
  end do

  var3 = yval(:,2)
  var4 = var3
  var4(0:1) = decimalPlaces(var3(0:1),0,True)
  var4(2:3) = decimalPlaces(var3(2:3),1,True)
  ;printVarSummary(var4)

  arr = new((/15,nvar/),float) 
  arr(:,0) = fspan(40,320,15)
  arr(:,2) = fspan(1.5,5,15)
  arr(:,1) = arr(:,0)
  arr(:,3) = arr(:,2)

  colors = ispan(2,17,1) 
  ;print(colors)
;************************************************************
  ;wks  = gsn_open_wks("pdf",diri+"picture/anth/cah")
  ;wks  = gsn_open_wks("pdf",diri+"picture/anth/ca")
  wks  = gsn_open_wks("pdf",diri+"picture/anth/fsds")
  gsn_define_colormap(wks,"WhiteBlueGreenYellowRed")
  plot = new(nvar,graphic)
  dum1 = new(N,graphic)
  dum2 = new(N,graphic)

  res                               = True
  res@gsnDraw                       = False       ; don't draw yet
  res@gsnFrame                      = False       ; don't advance frame yet
  res@gsnAddCyclic                  = False

  res@tmXBLabelFontHeightF          = 0.017
  res@tmYLLabelFontHeightF          = 0.017
  res@gsnLeftStringFontHeightF      = 0.025
  res@gsnRightStringFontHeightF     = 0.025
  res@pmLabelBarWidthF              = 0.65
  res@pmLabelBarOrthogonalPosF      = 0.15
  res@lbLabelFontHeightF            = 0.022

  ;res@lbLabelBarOn                  = False
  res@cnInfoLabelOn                 = False   ; turn off cn info label
  res@cnFillOn                      = True    ; turn on color
  res@cnFillMode                    = "CellFill"    ; turn on color
  res@cnLineLabelsOn                = False
  res@cnLinesOn                     = False
  res@cnLevelSelectionMode          = "ExplicitLevels"   ; set explicit contour levels
  ;res@cnFillColors                  = colors
  res@cnFillPalette                 = "cmp_b2r"
  ;res@cnLevels                      = arr

  res@mpDataBaseVersion             = "MediumRes"
  res@mpDataSetName                 = "Earth..4"
  res@mpOutlineOn                   = True
  res@mpOutlineBoundarySets         = "USStates"

  ;res@mpFillDrawOrder               = "PostDraw"
  ;res@mpAreaMaskingOn               = True
  ;res@mpMaskAreaSpecifiers          = "United States"
  res@mpOceanFillColor              = "white"
  res@mpInlandWaterFillColor        = "white"  
  res@mpLandFillColor               = "white"

  res@mpLimitMode                   = "LatLon"
  res@mpMinLatF                     = 24.
  res@mpMaxLatF                     = 50.
  res@mpMinLonF                     = 234.
  res@mpMaxLonF                     = 294.
  res@mpCenterLonF                  = 264.

  res@tiMainString                  = ""

  res@tmYROn                        = False
  res@tmXTOn                        = False
  res@tmXBMinorOn                   = False
  res@tmYLMinorOn                   = False

  do i=0,nvar-1
    res@gsnLeftString               = varname(i)
    res@gsnRightString              = "Median = "+var4(i)+unitname(i)
    res@cnLevels                    = arr(:,i)
    plot(i) = gsn_csm_contour_map(wks, var1(i,:,:), res )
  end do
;***************************************************** 
  res_text                    = True                  ; text mods desired
  res_text@txFontHeightF      = 0.015                 ; change text size
  res_text@txJust             = "CenterLeft"          ; text justification
  gsn_text_ndc(wks,"JJA",0.29,0.81,res_text)
  gsn_text_ndc(wks,"DJF",0.76,0.81,res_text) 
;************************************************
; create panel
;************************************************
  resP                              = True
  resP@gsnFrame                     = False                  ; don't advance panel plot
  ;resP@gsnPanelLabelBar             = True
  resP@lbLabelAutoStride            = True
  resP@pmLabelBarWidthF             = 0.6
  resP@pmLabelBarOrthogonalPosF     = -0.01
  resP@lbLabelFontHeightF           = 0.015
  resP@gsnPanelLeft                 = 0.06
  resP@gsnPanelXWhiteSpacePercent   = 3.
  ;resP@gsnPanelYWhiteSpacePercent   = 3.
  gsn_panel(wks,plot,(/2,2/),resP)
  frame(wks)    ; Advance the frame

end
