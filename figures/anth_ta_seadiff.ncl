;************************************************
begin
;************************************************
  nvar = 4
  nsea = 3
  N = 4
  clat = 224
  clon = 464
  ngrid = 5412
  ii=0

  varname = (/"(a) ~F8~D~F10~T~B~a_CLMU_nofd~N~","(b) ~F8~D~F10~T~B~a_CLMU_fd~N~","(c) ~F8~D~F10~T~B~a_CAEB_nofd~N~","(d) ~F8~D~F10~T~B~a_CAEB_fd~N~"/)
  seaname = (/"JJA","DJF","ANN"/)

  diri = "/Users/wly/post/"
  f = addfile(diri+"process/anth/anth.nc","r")
  var0 = f->var(0:1,:,:,0:nvar-1)

  var1 = var0(1,:,:,:)
  var1 = var0(1,:,:,:)-var0(0,:,:,:)

  var2 = new((/ngrid,nvar/),float)
  cnt=0
  do i=0,clat-1
    do j=0,clon-1
      if(.not.ismissing(var1(i,j,0)))then
        var2(cnt,:)=var1(i,j,:)
        cnt=cnt+1
      end if
    end do
  end do
  print(cnt)

  opt = True
  opt@PrintStat = True
  yval = new((/nvar,5/),"float")
  yval2 = new((/nvar,2/),"float")
  do i=0,nvar-1
    statb = stat_dispersion(var2(:,i), opt )
    yval(i,0) = statb(0)-statb(1);statb(6)-1.5*(statb(10)-statb(6));statb(2)
    yval(i,1) = statb(6)
    yval(i,2) = statb(8)
    yval(i,3) = statb(10)
    yval(i,4) = statb(0)+statb(1);statb(10)+1.5*(statb(10)-statb(6));statb(14)
    yval2(i,0) = statb(0)
    yval2(i,1) = statb(1)
  end do
  ;print(yval2)

  x = (/-3., -1., 1., 3./)	

  var3 = yval(:,2)
  var4 = decimalPlaces(var3,4,True)
  print(var4)

  arr    = fspan(-7,7,15)*0.001
  colors = ispan(5,20,1)

  vpx = (/0.05,0.38,0.05,0.38,0.71,0.38,0.71/)
  vpy = (/0.8,0.8,0.61,0.61,0.61,0.42,0.42/)
;************************************************
  wks  = gsn_open_wks("pdf",diri+"picture/anth/anth_ta_seadiff")
  gsn_define_colormap(wks,"so4_21")
  plot = new(N,graphic)

  res                               = True
  res@gsnDraw                       = False       ; don't draw yet
  res@gsnFrame                      = False       ; don't advance frame yet
  res@gsnAddCyclic                  = False

  res@vpWidthF                      = 0.27

  res@tmXBLabelFontHeightF          = 0.01
  res@tmYLLabelFontHeightF          = 0.01
  res@gsnLeftStringFontHeightF      = 0.011
  res@gsnRightStringFontHeightF     = 0.011
  ;res@pmLabelBarOrthogonalPosF      = 0.23
  ;res@pmLabelBarWidthF              = 0.55

  res@lbLabelBarOn                  = False
  res@cnInfoLabelOn                 = False   ; turn off cn info label
  res@cnFillOn                      = True    ; turn on color
  res@cnFillMode                    = "CellFill"    ; turn on color
  res@cnLineLabelsOn                = False
  res@cnLinesOn                     = False
  res@cnLevelSelectionMode          = "ExplicitLevels"   ; set explicit contour levels
  res@cnFillColors                  = colors
  res@cnLevels                      = arr

  res@mpDataBaseVersion             = "MediumRes"
  res@mpDataSetName                 = "Earth..4"
  res@mpOutlineOn                   = True
  res@mpOutlineBoundarySets         = "USStates"

  res@mpFillDrawOrder               = "PostDraw"
  res@mpAreaMaskingOn               = True
  res@mpMaskAreaSpecifiers          = "United States"
  res@mpOceanFillColor              = "white"
  res@mpInlandWaterFillColor        = "white"
  res@mpLandFillColor               = "white"
  res@mpInlandWaterFillColor        = "white"

  res@mpLimitMode                   = "LatLon"
  res@mpMinLatF                     = 24.
  res@mpMaxLatF                     = 50.
  res@mpMinLonF                     = 234.
  res@mpMaxLonF                     = 294.
  res@mpCenterLonF                  = 264.

  ; res@mpMinLatF                     = 25.     ; select a subregion 
  ; res@mpMaxLatF                     = 53.
  ; res@mpMinLonF                     = 235.
  ; res@mpMaxLonF                     = 293.
  ; res@mpCenterLonF                  = 264. 

  res@gsnLeftString                 = ""
  res@gsnRightString                = ""
  res@tiMainString                  = ""

  res@tmYROn                        = False
  res@tmXTOn                        = False
  res@tmXBMinorOn                   = False
  res@tmYLMinorOn                   = False

  j=0
  do i=0,nvar-1
    res@gsnLeftString               = varname(i)
    ;res@gsnRightString              = "Median = "+var4(i)+" K"
    ; res@vpXF                        = vpx(i)
    ; res@vpYF                        = vpy(i)
    plot(i) = gsn_csm_contour_map_ce(wks, var1(:,:,i), res )
  end do
;************************************************
;create panel
;************************************************
  resP                              = True
  resP@gsnFrame                     = False                  ; don't advance panel plot
  resP@gsnPanelLabelBar             = True
  resP@lbLabelAutoStride            = True
  resP@pmLabelBarWidthF             = 0.6
  resP@pmLabelBarHeightF            = 0.06
  resP@gsnPanelXWhiteSpacePercent   = 4
  resP@gsnPanelYWhiteSpacePercent   = 4
  resP@lbLabelFontHeightF           = 0.017
  gsn_panel(wks,plot,(/2,2/),resP)
  frame(wks)   
;**********************************************************
; add labelbar
;********************************************************** 
  ; labels = "" + arr    
  ; lbres                    = True      ; Set up a resource list for the labelbar.
  ; lbres@vpWidthF           = 0.6
  ; lbres@vpHeightF          = 0.05  
  ; lbres@lbFillColors       = colors
  ; lbres@lbMonoFillPattern  = True
  ; lbres@lbOrientation      = "Horizontal"
  ; lbres@lbPerimOn          = False
  ; lbres@lbLabelFontHeightF = 0.012
  ; lbres@lbLabelAlignment   = "InteriorEdges"
  ; gsn_labelbar_ndc(wks,dimsizes(arr)+1,labels,0.2,0.15,lbres)
  
  ; frame(wks)    ; Advance the frame
end 

