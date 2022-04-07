;************************************************
begin
;************************************************
  nvar = 6
  nvar2 = 3
  N = nvar
  clat = 224
  clon = 464
  ngrid = 5412
  ii=0
do ii=0,1

  varname = (/"(a) ~F33~l~B~~F10~all","(b) ~F33~l~B~0","(c) ~F33~l~B~1+2+3","(d) ~F33~l~B~1","(e) ~F33~l~B~2","(f) ~F33~l~B~3"/)
  seaname = (/"JJA","DJF"/)

  diri = "/Users/wly/post/"
  f = addfile(diri+"process/anth/anth.nc","r")
  var0=new((/clat,clon,nvar/),float)
  var0(:,:,2:nvar-1) = f->var(ii,:,:,4:7)
  var0(:,:,0)=dim_sum_n(var0,2)
  var0(:,:,1)=var0(:,:,2)
  var0(:,:,2)=var0(:,:,3)+var0(:,:,4)+var0(:,:,5)

  var1 = var0
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

  opt = False
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
  print(yval(:,0))
  print(yval(:,4))

  var3 = yval(:,2)
  var4 = decimalPlaces(var3,0,True)

  arr = new((/15,nvar/),float) 
  arr(:,0) = fspan(-14,-7,15)*10
  arr(:,1) = arr(:,0)
  do i=2,5
    arr(:,i) = fspan(-7,7,15)*5
  end do
  colors = ispan(2,32,2)
  colors2 = ispan(10,55,3)
  ;colors = (/2,3,4,5,6,8,10,12,13,14,15,16,17,18,19,20,22,24,39,42,45,48,51,54,57/)
  ;colors = ispan(5,20,1)

  x = (/-5., -3., -1., 1., 3., 5./)	
;************************************************
  wks  = gsn_open_wks("pdf",diri+"picture/anth/anth_lambda-"+seaname(ii))
  gsn_define_colormap(wks,"cmp_b2r")
  ;gsn_define_colormap(wks,"so4_21")
  plot = new(N,graphic)

  res                               = True
  res@gsnDraw                       = False       ; don't draw yet
  res@gsnFrame                      = False       ; don't advance frame yet
  res@gsnAddCyclic                  = False

  res@tmXBLabelFontHeightF          = 0.023
  res@tmYLLabelFontHeightF          = 0.023
  res@gsnLeftStringFontHeightF      = 0.037
  res@gsnRightStringFontHeightF     = 0.032
  res@pmLabelBarOrthogonalPosF      = 0.23
  res@lbLabelFontHeightF            = 0.025
  res@pmLabelBarWidthF              = 0.7

  ;res@lbLabelBarOn                  = False
  res@cnInfoLabelOn                 = False   ; turn off cn info label
  res@cnFillOn                      = True    ; turn on color
  res@cnFillMode                    = "CellFill"    ; turn on color
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

  j=0
  do i=0,nvar-1
    res@gsnLeftString               = varname(i)
    res@gsnRightString              = "Median = "+var4(i)+" W m~S~-2~N~ K~S~-1"
    res@cnLevels                    = arr(:,i)
    if(i.gt.1)then
      res@cnFillColors                  = colors2
    end if
    plot(i) = gsn_csm_contour_map_ce(wks, var1(:,:,i), res )
  end do
;************************************************
;create panel
;************************************************
  resP                              = True
  resP@gsnFrame                     = False                  ; don't advance panel plot
  ;resP@gsnPanelLabelBar             = True
  resP@lbLabelAutoStride            = True
  resP@lbBoxLinesOn = False
  resP@pmLabelBarWidthF             = 0.6
  resP@pmLabelBarHeightF            = 0.06
  resP@gsnPanelXWhiteSpacePercent   = 4
  resP@gsnPanelYWhiteSpacePercent   = 2
  resP@lbLabelFontHeightF           = 0.017
  gsn_panel(wks,plot,(/2,3/),resP)
  frame(wks)   
end do
end 

