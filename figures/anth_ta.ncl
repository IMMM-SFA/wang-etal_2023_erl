;************************************************
begin
;************************************************
  nvar = 4
  nsea = 2
  N = 4
  clat = 224
  clon = 464
  ngrid = 5412

  varname = (/"(a) CLMU","(b) CLMU","(c) Forcing-feedback framework","(d) Forcing-feedback framework"/)
  varname2 = (/"CLMU","Forcing-feedback framework"/)
  varname3 = (/"Number of urban grids",""/)
  figname = (/"(e)","(f)"/)
  seaname = (/"JJA","DJF"/)

  var0 = new((/clat,clon,nvar/),float)

  diri = "/Users/wly/post/"
  f = addfile(diri+"process/anth/anth.nc","r")
  var0(:,:,0) = f->var(0,:,:,1)
  var0(:,:,1) = f->var(1,:,:,1)
  var0(:,:,2) = f->var(0,:,:,3)
  var0(:,:,3) = f->var(1,:,:,3)
  var1 = var0

  var2 = new((/ngrid,nvar/),float,-999.)
  cnt=0
  cnt2=0
  cnt3=0
  do i=0,clat-1
    do j=0,clon-1
      if(.not.ismissing(var1(i,j,0)))then
        var2(cnt,:)=var1(i,j,:)
        cnt=cnt+1
        if(var1(i,j,0).gt.0.01)then
          cnt2=cnt2+1
        end if
        if(var1(i,j,1).gt.0.01)then
          cnt3=cnt3+1
        end if        
      end if
    end do
  end do

  opt = True
  opt@PrintStat = False
  yval = new((/nvar,5/),"float")
  yval2 = new((/nvar,2/),"float")
  outlier = new((/nvar,2/),"float")
  do i=0,nvar-1
    statb = stat_dispersion(var2(:,i), opt )
    yval(i,0) = statb(0)-statb(1);statb(6)-1.5*(statb(10)-statb(6));statb(2)
    yval(i,1) = statb(6)
    yval(i,2) = statb(8)
    yval(i,3) = statb(10)
    yval(i,4) = statb(0)+statb(1);statb(10)+1.5*(statb(10)-statb(6));statb(14)
    yval2(i,0) = statb(0)
    yval2(i,1) = statb(1)
    outlier(i,0) = statb(0)-statb(1)*3
    outlier(i,1) = statb(0)+statb(1)*3
  end do

  print(outlier)

  var3=var2
  cnt1=0
  cnt2=0
  do i=0,ngrid-1
    if(var2(i,2).lt.outlier(2,0) .or. var2(i,2).gt.outlier(2,1)) then
      print(outlier(2,:))
      print(var2(i,2))
      var3(i,0)=-999.
      var3(i,2)=-999.
      cnt1=cnt1+1
    end if
    if(var2(i,3).lt.outlier(3,0) .or. var2(i,3).gt.outlier(3,1)) then
      print(outlier(3,:))
      print(var2(i,3))
      var3(i,1)=-999.
      var3(i,3)=-999.
      cnt2=cnt2+1
    end if
  end do
  print(cnt1)
  print(cnt2)

  var_r2 = new((/2/),float)
  var_r2(0)=escorc(var3(:,0),var3(:,2))
  var_r2(1)=escorc(var3(:,1),var3(:,3))
  print(var_r2)

  x = (/-3., -1., 1., 3./)	

  delete(var3)
  var3 = yval(:,2)
  var4 = decimalPlaces(var3,3,True)
  print(var4)

  arr    = fspan(4,18,15)*0.001
  colors = ispan(9,255,16)

  vpx = (/0.08,0.52/)
  vpy = (/0.95,0.71/)

  color1 = (/"darkorange2","coral2"/)
  color2 = (/"palegreen4","dodgerblue3"/)
;************************************************
  wks  = gsn_open_wks("pdf",diri+"picture/anth/anth_ta")
  gsn_define_colormap(wks,"WhiteBlueGreenYellowRed")
  plot = new(N,graphic)

  res                               = True
  ;res@gsnDraw                       = False       ; don't draw yet
  res@gsnFrame                      = False       ; don't advance frame yet
  res@gsnAddCyclic                  = False

  res@vpWidthF                      = 0.374
  res@tmXBLabelFontHeightF          = 0.009
  res@tmYLLabelFontHeightF          = 0.009
  res@gsnLeftStringFontHeightF      = 0.0115
  res@gsnRightStringFontHeightF     = 0.0115

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
  res@mpUSStateLineThicknessF       = 0.7

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

  do i=0,nvar-1
    res@gsnLeftString               = varname(i)
    res@gsnRightString              = var4(i)+" K (W ~N~m~S~-2~N~)~S~-1"
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
    plot(i) = gsn_csm_contour_map_ce(wks, var1(:,:,i), res )
  end do

;**********************************************************
; add labelbar
;********************************************************** 
  labels = "" + arr    
  lbres                    = True      ; Set up a resource list for the labelbar.
  lbres@vpWidthF           = 0.05
  lbres@vpHeightF          = 0.38  
  lbres@lbFillColors       = colors
  lbres@lbMonoFillPattern  = True
  lbres@lbPerimOn          = False
  lbres@lbLabelFontHeightF = 0.011
  lbres@lbLabelAlignment   = "InteriorEdges"
  gsn_labelbar_ndc(wks,dimsizes(arr)+1,labels,0.926,0.85,lbres)  
;***************************************************** 
  res_text                    = True                  ; text mods desired
  res_text@txFontHeightF      = 0.013                 ; change text size
  res_text@txJust             = "CenterLeft"          ; text justification
  gsn_text_ndc(wks,"JJA",0.255,0.92,res_text)
  gsn_text_ndc(wks,"DJF",0.695,0.92,res_text) 
  
  delete(res)
  delete(plot)
;************************************************************
  plot = new(2,graphic)

  res                               = True
  res@gsnFrame                      = False       ; don't advance frame yet

  res@vpYF                          = 0.391
  res@vpWidthF                      = 0.374
  res@vpHeightF                     = 0.15

  res@tmXBLabelFontHeightF          = 0.01
  res@tmYLLabelFontHeightF          = 0.01
  res@tiXAxisFontHeightF            = 0.012
  res@tiYAxisFontHeightF            = 0.01
  res@tmXBLabelFontThicknessF       = 0.00000001
  res@tmYLLabelFontThicknessF       = 0.00000001
  res@tiXAxisFontThicknessF         = 0.9
  res@tiYAxisFontThicknessF         = 0.00000001
  res@tiXAxisString                 = "~F8~D~F10~T~B~a~N~/~F8~D~F10~Q~B~AH"

  res@trYMinF                       = 0
  res@trYMaxF                       = 1200

  res@tmXBOn                        = True
  res@tmXTOn                        = False
  res@tmYROn                        = False
  res@tmXBLabelsOn                  = True
  res@tmXBMode                      = "Explicit"
  res@tmXBValues                    = fspan(0,1,4)  ;
  res@tmXBLabels                    = fspan(0,30,4)*0.001 ;
  res@tmYLMode                      = "Explicit"
  res@tmYLValues                    = fspan(0,1500.,4)
  res@tmYLLabels                    = fspan(0,1500.,4)

  res@gsnHistogramBinIntervals      = fspan(0,30,61)*0.001
  res@gsnHistogramBarWidthPercent   = 100.     
  res@gsFillColor                   = (/"transparent"/)
;*****************************************************   
; Manually create and attach legend
;***************************************************** 
  res_text                          = True                  ; text mods desired
  res_text@txFontHeightF            = 0.012                 ; change text size
  res_text@txJust                   = "CenterLeft"          ; text justification
  gsn_text_ndc(wks,figname(0),vpx(0),0.407,res_text)
  gsn_text_ndc(wks,figname(1),vpx(1),0.407,res_text)
  res_text@txFontHeightF            = 0.0095                 ; change text size

  res_lines                         = True                  ; polyline mods desired
  res_lines@gsLineThicknessF        = 1.7                   ; line thicker
  xx = (/0.43,0.5,0.5,0.43,0.43/)

  do i=0,1
    res@vpXF                        = vpx(i)
    res@tiYAxisString               = varname3(i)  
    res@gsEdgeColor                 = color1(i)             ; change color of edge
    res@gsEdgeThicknessF            = 1.3
    plot1 = gsn_histogram(wks,var2(:,i+2),res)    

    yy = (/1000,1000,1045,1045,1000/)
    res_lines@gsLineColor           = color1(i)             ; line color
    dum1 = gsn_add_polyline(wks,plot1,xx,yy,res_lines)      ; add polyline
    dum2 = gsn_add_text(wks,plot1,"CLMU",0.53,1025,res_text)   ; add text
  
    yy = (/830,830,875,875,830/)
    res_lines@gsLineColor           = color2(i)                             
    dum3 = gsn_add_polyline(wks,plot1,xx,yy,res_lines)             
    dum4 = gsn_add_text(wks,plot1,"Forcing-feedback framework",0.53,840,res_text)    
  
    res@gsEdgeColor                 = color2(i)             ; change color again
    res@gsEdgeThicknessF            = 1.3
    plot2 = gsn_histogram(wks,var2(:,i),res)            
    overlay(plot1,plot2)    
    draw(plot1)
  end do

  frame(wks)    ; Advance the frame
  delete(res)
  delete(plot1)
  delete(plot2)
  delete(plot)

end 

