;************************************************************
begin
;************************************************************
  nvar = 4
  N = nvar
  clat = 224
  clon = 464
  ngrid = 5412

  ;varname = (/"(a) ~F8~D~F10~T~B~a_fd~N~/~F8~D~F10~T~B~a_nofd~N~-1","(b) ~F8~D~F10~T~B~a_fd~N~/~F8~D~F10~T~B~a_nofd~N~-1","(c) ~F8~-l~B~~F10~1+2+3~N~/~F8~l~B~~F10~all","(d) ~F8~-l~B~~F10~1+2+3~N~/~F8~l~B~~F10~all"/)
  ;varname = (/"(a) ~F10~(~F8~D~F10~T~B~a_fd~N~-~F8~D~F10~T~B~a_nofd~N~)/~F8~D~F10~T~B~a_nofd~N~","(b) ~F10~(~F8~D~F10~T~B~a_fd~N~-~F8~D~F10~T~B~a_nofd~N~)/~F8~D~F10~T~B~a_nofd~N~","(d) ~F8~-l~B~~F10~1+2+3~N~/~F8~l~B~~F10~all","(e) ~F8~-l~B~~F10~1+2+3~N~/~F8~l~B~~F10~all"/)
  ;varname = (/"(a) ~F10~((~F8~D~F10~T~B~a~N~/~F8~D~F10~Q~B~AH~N~)_fd~N~-(~F8~D~F10~T~B~a~N~/~F8~D~F10~Q~B~AH~N~)_nofd~N~)/(~F8~D~F10~T~B~a~N~/~F8~D~F10~Q~B~AH~N~)_nofd~N~","(b) ~F10~(~F8~D~F10~T~B~a_fd~N~-~F8~D~F10~T~B~a_nofd~N~)/~F8~D~F10~T~B~a_nofd~N~","(d) ~F8~-l~B~~F10~1+2+3~N~/~F8~l~B~~F10~all","(e) ~F8~-l~B~~F10~1+2+3~N~/~F8~l~B~~F10~all"/)
  ;varname2 = (/"~F10~(~F8~D~F10~T~B~a_fd~N~-~F8~D~F10~T~B~a_nofd~N~)/~F8~D~F10~T~B~a_nofd~N~","~F8~-l~B~~F10~1+2+3~N~/~F8~l~B~~F10~all"/)
  varname = (/"(a) ~F10~(FD-NOFD)/NOFD","(b) ~F10~(FD-NOFD)/NOFD","(d) ~F8~-l~B~~F10~1+2+3~N~/~F8~l~B~~F10~all","(e) ~F8~-l~B~~F10~1+2+3~N~/~F8~l~B~~F10~all"/)
  varname2 = (/"~F10~(FD-NOFD)/NOFD","~F8~-l~B~~F10~1+2+3~N~/~F8~l~B~~F10~all"/)
  figname = (/"(c)","(f)"/)
  seaname = (/"JJA","DJF"/)

  diri = "/Users/wly/post/"
  f = addfile(diri+"process/anth/anth.nc","r")
  var0 = f->var(0:1,:,:,16:17)

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

  opt = True
  opt@PrintStat = False
  yval = new((/N,5/),"float")
  do i=0,N-1
    statb = stat_dispersion(var2(:,i), opt )
    yval(i,0) = statb(0)-statb(1);statb(6)-1.5*(statb(10)-statb(6));statb(2)
    yval(i,1) = statb(6)
    yval(i,2) = statb(8)
    yval(i,3) = statb(10)
    yval(i,4) = statb(0)+statb(1);statb(10)+1.5*(statb(10)-statb(6));statb(14)
  end do
  print(yval(:,0))
  print(yval(:,4))

  var3 = yval(:,2)
  var4 = decimalPlaces(var3,0,True)
  print(var4)

  ;arr = fspan(-1,11,13)*0.0005
  arr = fspan(-5,5,11)*10
  colors = ispan(5,65,5)
  ;print(colors)

  vpx = (/0.04,0.467,0.905/)
  vpy = (/0.95,0.71/)
  vpy2 = (/0.8575,0.617/)

  color1 = (/"coral2","darkorange2"/)
  color2 = (/"dodgerblue3","palegreen4"/)  
;************************************************************
  wks  = gsn_open_wks("pdf",diri+"picture/anth/anth_ta_diff")
  gsn_define_colormap(wks,"cmp_b2r")
  plot = new(N,graphic)

  res                               = True
  ;res@gsnDraw                       = False       ; don't draw yet
  res@gsnFrame                      = False       ; don't advance frame yet
  res@gsnAddCyclic                  = False

  res@vpWidthF                      = 0.373
  res@tmXBLabelFontHeightF          = 0.008
  res@tmYLLabelFontHeightF          = 0.008
  res@gsnLeftStringFontHeightF      = 0.011
  res@gsnRightStringFontHeightF     = 0.011

  res@lbLabelBarOn                  = False
  res@cnInfoLabelOn                 = False   ; turn off cn info label
  res@cnFillOn                      = True    ; turn on color
  res@cnFillMode                    = "CellFill"
  res@cnLineLabelsOn                = False
  res@cnLinesOn                     = False
  res@cnLevelSelectionMode          = "ExplicitLevels"   ; set explicit contour levels
  res@cnFillColors                  = colors
  ;res@cnFillPalette                 = "cmp_b2r"
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

  res@gsnLeftString                 = ""
  res@gsnRightString                = ""
  res@tiMainString                  = ""

  res@tmYROn                        = False
  res@tmXTOn                        = False
  res@tmXBMinorOn                   = False
  res@tmYLMinorOn                   = False

  do i=0,N-1
    res@gsnLeftString                 = varname(i)
    res@gsnRightString                  = "Median = "+var4(i)+"%"
    if(i.eq.0 .or. i.eq.2) then
      res@vpXF                      = vpx(0)
    else
      res@vpXF                      = vpx(1)
    end if
    if(i.eq.0 .or. i.eq.1) then
      res@vpYF                      = vpy(0)
    else
      res@vpYF                      = vpy(1)
    end if    
    plot(i) = gsn_csm_contour_map_ce(wks, var1(i,:,:), res )
  end do
;**********************************************************
; add labelbar
;********************************************************** 
  labels = "" + arr    
  lbres                    = True      ; Set up a resource list for the labelbar.
  lbres@vpWidthF           = 0.55
  lbres@vpHeightF          = 0.05  
  lbres@lbFillColors       = colors
  lbres@lbMonoFillPattern  = True
  lbres@lbOrientation      = "Horizontal"
  lbres@lbPerimOn          = False
  lbres@lbLabelFontHeightF = 0.011
  lbres@lbLabelAlignment   = "InteriorEdges"
  gsn_labelbar_ndc(wks,dimsizes(arr)+1,labels,0.17,0.42,lbres)  

  delete(res)
  delete(plot)
;************************************************************
  plot = new(2,graphic)

  res                               = True
  res@gsnFrame                      = False       ; don't advance frame yet

  res@vpXF                          = vpx(2)
  res@vpWidthF                      = 0.08
  res@vpHeightF                     = 0.1615

  res@tmXBLabelFontHeightF          = 0.008
  res@tmYLLabelFontHeightF          = 0.008
  res@tiXAxisFontHeightF            = 0.008
  res@tiYAxisFontHeightF            = 0.008
  res@tiXAxisFontThicknessF         = 0.001
  res@tiYAxisFontThicknessF         = 0.001
  res@tiXAxisString                 = "Number of urban grids"

  res@trXMinF                       = 0
  res@trXMaxF                       = 1500

  res@tmXBOn                        = True
  res@tmXTOn                        = False
  res@tmYROn                        = False
  res@tmXBLabelsOn                  = True
  res@tmXBMode                      = "Explicit"
  res@tmXBValues                    = fspan(0,1500.,4)
  res@tmXBLabels                    = fspan(0,1500.,4)
  res@tmYLMode                      = "Explicit"
  res@tmYLValues                    = fspan(0,1,5)
  res@tmYLLabels                    = fspan(-20,60,5);*0.001

  res@gsnHistogramHorizontal        = True
  res@gsnHistogramBinIntervals      = fspan(-20,60,41);*0.001
  res@gsnHistogramBarWidthPercent   = 100.     
  res@gsFillColor                   = (/"transparent"/)
;*****************************************************   
; Manually create and attach legend
;***************************************************** 
  res_text                          = True                  ; text mods desired
  res_text@txFontHeightF            = 0.011                 ; change text size
  res_text@txJust                   = "CenterLeft"          ; text justification
  gsn_text_ndc(wks,figname(0),.905,.8752,res_text)
  gsn_text_ndc(wks,figname(1),.905,.6342,res_text)
  res_text@txFontHeightF            = 0.013                 ; change text size
  gsn_text_ndc(wks,"JJA",0.22,0.91,res_text)
  gsn_text_ndc(wks,"DJF",0.644,0.91,res_text) 
  res_text@txFontHeightF            = 0.007                 ; change text size

  res_lines                         = True                  ; polyline mods desired
  res_lines@gsLineThicknessF        = 1.4                    ; line thicker
  xx = (/200,550,550,200,200/)

  do i=0,1
    res@vpYF                        = vpy2(i)
    res@tiYAxisString               = varname2(i)
    res@gsEdgeColor                 = color1(i)
    res@gsEdgeThicknessF            = 0.6
    plot1 = gsn_histogram(wks,var2(:,i*2+1),res)    

    yy = (/0.89,0.89,0.91,0.91,0.89/)
    res_lines@gsLineColor           = color1(i) 
    dum1 = gsn_add_polyline(wks,plot1,xx,yy,res_lines)
    dum2 = gsn_add_text(wks,plot1,"DJF",700,0.9,res_text)
  
    yy = (/0.79,0.79,0.81,0.81,0.79/)
    res_lines@gsLineColor           = color2(i)                             
    dum3 = gsn_add_polyline(wks,plot1,xx,yy,res_lines)             
    dum4 = gsn_add_text(wks,plot1,"JJA",700,0.8,res_text)    
  
    res@gsEdgeColor                 = color2(i)
    ;res@gsEdgeThicknessF            = 0.6
    plot2 = gsn_histogram(wks,var2(:,i*2),res)            
    overlay(plot1,plot2)    
    draw(plot1)
  end do

  frame(wks)    ; Advance the frame
end
