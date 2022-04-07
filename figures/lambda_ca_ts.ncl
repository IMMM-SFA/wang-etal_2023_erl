;************************************************************
begin
;************************************************************
  nvar = 9
  nsea = 3
  N = 6
  yr = 20
  time = 12*yr
  clat = 224
  clon = 464
  ngrid = 5412
  do ii =0,1
  ;ii = 0

  varname = (/"(a) ~F10~c~B~ah","(b) ~F10~c~B~a_wt","(c) ~F10~c~B~a","(d) ~F8~D~F10~T~B~s_wt~N~/~F8~D~F10~T~B~a","(e) ~F8~q~F10~~B~atm~N~-~F10~T~F10~~B~a~N~","(f) ~F8~D~F10~c~B~ah~N~/~F8~D~F10~T~B~a"/)
  unitname = (/" m s~S~-1"," m s~S~-1"," m s~S~-1",""/)
  seaname = (/"JJA","DJF","ANN"/)

  diri = "/Users/wly/post/"
  f = addfile(diri+"process/anth/anth.nc","r")
  var0 = f->var(ii,:,:,:)

  var1 = var0(:,:,0:nvar-1)
  var1(:,:,0:2) = var0(:,:,4:6)
  var1(:,:,3:8) = var0(:,:,8:13)

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
  ;print(cnt)

  opt = True
  opt@PrintStat = True
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
  var4(0:2) =  decimalPlaces(var3(0:2),0,True)

  corr = new(N,float)
  ; corr(0)=escorc(var2(:,3),var2(:,0))
  ; corr(1)=escorc(var2(:,3),var2(:,1))

  corr(0)=escorc(var2(:,0),var2(:,3))
  corr(1)=escorc(var2(:,0),var2(:,4))
  corr(2)=escorc(var2(:,1),var2(:,5))
  corr(3)=escorc(var2(:,1),var2(:,6))
  corr(4)=escorc(var2(:,2),var2(:,7))
  corr(5)=escorc(var2(:,2),var2(:,8))
  corr2 = decimalPlaces(corr,2,True)
  ;print(corr2)
;end do
;exit
  arr = new((/15,N/),float) 
  arr(:,0) = fspan(4.5,11.5,15)*0.01
  arr(:,1) = fspan(20,34,15)*0.001
  arr(:,2) = fspan(12,19,15)*0.001
  arr(:,3) = fspan(6,20,15)*0.1
  arr(:,4) = fspan(0,14,15)*0.1*(-1)
  arr(:,5) = fspan(2,4.8,15)*0.01
  colors = ispan(5,20,1)
;************************************************************
  wks  = gsn_open_wks("pdf",diri+"picture/anth/lambda_ca_ts-"+seaname(ii))
  gsn_define_colormap(wks,"so4_21")
  plot = new(N,graphic)

  res                               = True
  res@gsnDraw                       = False       ; don't draw yet
  res@gsnFrame                      = False       ; don't advance frame yet
  res@gsnAddCyclic                  = False

  res@tmXBLabelFontHeightF          = 0.025
  res@tmYLLabelFontHeightF          = 0.025
  res@gsnLeftStringFontHeightF      = 0.03
  res@gsnRightStringFontHeightF     = 0.03 
;  res@tiMainFontHeightF             = 0.005
;  res@pmLabelBarWidthF              = 0.8
;  res@lbOrientation                 = "Vertical"
 res@pmLabelBarOrthogonalPosF      = 0.2
 res@lbLabelFontHeightF            = 0.03

  ;res@lbLabelBarOn                  = False
  res@cnInfoLabelOn                 = False   ; turn off cn info label
  res@cnFillOn                      = True    ; turn on color
  res@cnFillMode                    = "CellFill"
  res@cnLineLabelsOn                = False
  res@cnLinesOn                     = False
  res@cnLevelSelectionMode          = "ExplicitLevels"   ; set explicit contour levels
  res@cnFillColors                  = colors
  ;res@cnLevels                      = arr

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
    ;res@gsnRightString                = "~F10~r = "+corr2(i);+"%"
    res@gsnRightString                = "Median = "+var4(i+3);+"%"
    res@cnLevels                      = arr(:,i)
    plot(i) = gsn_csm_contour_map_ce(wks, var1(:,:,i+3), res )
  end do

;************************************************
; create panel
;************************************************
  resP                              = True
  resP@gsnFrame                     = False                  ; don't advance panel plot
  resP@gsnPanelCenter               = False
  ;resP@gsnPanelLabelBar             = True
  resP@lbLabelAutoStride            = True
  resP@pmLabelBarWidthF             = 0.6
  resP@pmLabelBarOrthogonalPosF     = -0.01
  resP@lbLabelFontHeightF           = 0.015
  resP@gsnPanelLeft                 = 0.06
  resP@gsnPanelXWhiteSpacePercent   = 3.
  resP@gsnPanelYWhiteSpacePercent   = 3.
  gsn_panel(wks,plot,(/3,2/),resP)
  frame(wks)    ; Advance the frame
  end do
end
