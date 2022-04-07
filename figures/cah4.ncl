;************************************************************
begin
;************************************************************
  nvar = 6
  N = 3
  clat = 224
  clon = 464
  ngrid = 5412
  
  varname = (/"~F10~c~B~a~N~"/)
  unitname = (/" m s~S~-1"/)
  seaname = (/"JJA","DJF"/)
  figname = (/"(a) AH1", "(b) AH1", "(c) AH2", "(d) AH2", "(e) AH3", "(f) AH3"/)

  var0 = new((/nvar,clat,clon/),float)
  diri = "/Users/wly/post/"
  f1 = addfile(diri+"process/anth/anth.nc","r")
  f2 = addfile(diri+"process/anth/anth2.nc","r")
  f3 = addfile(diri+"process/anth/anth3.nc","r")
  var0(0:1,:,:) = f1->var(0:1,:,:,11)  
  var0(2:3,:,:) = f2->var(0:1,:,:,11)  
  var0(4:5,:,:) = f3->var(0:1,:,:,11)  

  var1 = var0
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
  var4 = decimalPlaces(var3,4,True)

  arr = fspan(1.1,1.7,13)*0.01
  colors = (/59,73,87,101,115,143,157,171,185,199,213,227,241,255/)

  ;colors = ispan(130,250,5) 
  ;print(colors)
;************************************************************
  wks  = gsn_open_wks("pdf",diri+"picture/anth/cs2")
  gsn_define_colormap(wks,"NEO_div_vegetation_a")
  plot = new(nvar,graphic)
  dum = new((/nvar,N/),graphic)

  res                               = True
  res@gsnDraw                       = False       ; don't draw yet
  res@gsnFrame                      = False       ; don't advance frame yet
  res@gsnAddCyclic                  = False

  res@tmXBLabelFontHeightF          = 0.022
  res@tmYLLabelFontHeightF          = 0.022
  res@gsnLeftStringFontHeightF      = 0.03
  res@gsnRightStringFontHeightF     = 0.03
  ;res@tiMainFontHeightF             = 0.03
  ;res@pmLabelBarWidthF              = 0.75
  ;res@pmLabelBarOrthogonalPosF      = 0.15
  ;res@lbLabelFontHeightF            = 0.035

  res@lbLabelBarOn                  = False
  res@cnInfoLabelOn                 = False   ; turn off cn info label
  res@cnFillOn                      = True    ; turn on color
  res@cnFillMode                    = "CellFill"    ; turn on color
  res@cnLineLabelsOn                = False
  res@cnLinesOn                     = False
  res@cnLevelSelectionMode          = "ExplicitLevels"   ; set explicit contour levels
  res@cnLevels                      = arr
  ;res@cnFillColors                  = colors
  res@cnFillPalette                 = "NEO_div_vegetation_a"

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

  ;res@gsnLeftString                 = ""
  ;res@gsnRightString                = ""
  res@tiMainString                  = ""

  res@tmYROn                        = False
  res@tmXTOn                        = False
  res@tmXBMinorOn                   = False
  res@tmYLMinorOn                   = False

  polyres                    = True          ; poly marker mods desired 
  polyres@gsMarkerIndex      = 12             ; choose circle as polymarker
  polyres@gsMarkerSizeF      = 0.012          ; select size to avoid streaking
  polyres@gsMarkerThicknessF = 2.
  polyres@gsMarkerColor      = "red";"grey50";"slateblue";

  do i=0,nvar-1
    res@gsnLeftString               = figname(i)
    res@gsnRightString              = "Median = "+var4(i)+unitname
    plot(i) = gsn_csm_contour_map(wks, var1(i,:,:), res )
  end do
;***************************************************** 
  res_text                    = True                  ; text mods desired
  res_text@txFontHeightF      = 0.019                 ; change text size
  res_text@txJust             = "CenterLeft"          ; text justification
  gsn_text_ndc(wks,"JJA",0.29,0.94,res_text)
  gsn_text_ndc(wks,"DJF",0.76,0.94,res_text) 
;************************************************
; create panel
;************************************************
  resP                              = True
  resP@gsnFrame                     = False                  ; don't advance panel plot
  resP@gsnPanelLabelBar             = True
  resP@lbLabelAutoStride            = True
  resP@pmLabelBarWidthF             = 0.7
  resP@pmLabelBarOrthogonalPosF     = -0.01
  resP@lbLabelFontHeightF           = 0.018
  resP@gsnPanelLeft                 = 0.06
  resP@gsnPanelXWhiteSpacePercent   = 3.
  resP@gsnPanelYWhiteSpacePercent   = 3.
  gsn_panel(wks,plot,(/3,2/),resP)
  frame(wks)    ; Advance the frame

end
