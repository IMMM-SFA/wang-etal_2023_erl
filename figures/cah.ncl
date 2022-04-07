;************************************************************
begin
;************************************************************
  nvar = 2
  N = 4
  clat = 224
  clon = 464
  ngrid = 5412
  
  ;varname = (/"~F10~c~B~ah~N~"/)
  varname = (/"~F10~c~B~a~N~"/)
  unitname = (/" m s~S~-1"/)
  seaname = (/"(a) JJA","(b) DJF"/)

  diri = "/Users/wly/post/"
  f = addfile(diri+"process/anth/anth.nc","r")
  var0 = f->var(0:1,:,:,8)
  ;var0 = f->var(0:1,:,:,10)
  ;var0 = f->var(0:1,:,:,12)
  lat  = f->lat
  lon  = f->lon

  ilat = (/138,135,37,101/)
  ilon = (/431,298,237,20/)
  print(lat(ilat))
  print(lon(ilon))
  do i=0,N-1
    print(var0(0,ilat(i),ilon(i)))
  end do

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
  var4 = decimalPlaces(var3,3,True)
  ;printVarSummary(var4)

  arr = fspan(6.,9.,13)*0.01
  colors = ispan(130,255,9)  
  print(colors)
;************************************************************
  wks  = gsn_open_wks("pdf",diri+"picture/anth/ca")
  ;wks  = gsn_open_wks("pdf",diri+"picture/anth/ca")
  ;wks  = gsn_open_wks("pdf",diri+"picture/anth/fsds")
  gsn_define_colormap(wks,"NEO_div_vegetation_a")
  plot = new(nvar,graphic)
  dum1 = new(N,graphic)
  dum2 = new(N,graphic)

  res                               = True
  res@gsnDraw                       = False       ; don't draw yet
  res@gsnFrame                      = False       ; don't advance frame yet
  res@gsnAddCyclic                  = False

  res@tmXBLabelFontHeightF          = 0.015
  res@tmYLLabelFontHeightF          = 0.015
  res@gsnLeftStringFontHeightF      = 0.02
  res@gsnRightStringFontHeightF     = 0.02
  res@tiMainFontHeightF             = 0.03
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
  res@cnFillColors                  = colors
  res@cnLevels                      = arr
  ;res@cnFillPalette                 = "WhiteGreen"

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
  res@tiMainString                  = varname

  res@tmYROn                        = False
  res@tmXTOn                        = False
  res@tmXBMinorOn                   = False
  res@tmYLMinorOn                   = False

  do i=0,nvar-1
    ;if(i.gt.0)then
      res@tiMainString              = ""
    ;end if
    res@gsnLeftString               = seaname(i)
    res@gsnRightString              = "Median = "+var4(i)+unitname
    plot(i) = gsn_csm_contour_map(wks, var0(i,:,:), res )
  end do

  polyres                    = True          ; poly marker mods desired 
  polyres@gsMarkerIndex      = 12             ; choose circle as polymarker
  polyres@gsMarkerSizeF      = 0.015          ; select size to avoid streaking
  polyres@gsMarkerThicknessF = 2.5
  polyres@gsMarkerColor      = "red";"grey50";"slateblue";
  do i=0,N-1
    dum1(i) = gsn_add_polymarker(wks, plot(0), lon(ilon(i)),lat(ilat(i)), polyres)
    dum2(i) = gsn_add_polymarker(wks, plot(1), lon(ilon(i)),lat(ilat(i)), polyres)
  end do

;************************************************
; create panel
;************************************************
  resP                              = True
  resP@gsnFrame                     = False                  ; don't advance panel plot
  resP@gsnPanelLabelBar             = True
  resP@lbLabelAutoStride            = True
  resP@pmLabelBarWidthF             = 0.6
  resP@pmLabelBarOrthogonalPosF     = -0.01
  resP@lbLabelFontHeightF           = 0.017
  resP@gsnPanelLeft                 = 0.06
  ;resP@gsnPanelXWhiteSpacePercent   = 3.
  ;resP@gsnPanelYWhiteSpacePercent   = 3.
  gsn_panel(wks,plot,(/2,1/),resP)
  frame(wks)    ; Advance the frame

end
