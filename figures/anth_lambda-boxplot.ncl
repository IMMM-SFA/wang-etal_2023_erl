;************************************************
begin
;************************************************
  nvar = 6
  N = nvar
  clat = 224
  clon = 464
  ngrid = 6369

  diri = "/Users/wly/post/"
  f = addfile(diri+"process/anth/anth.nc","r")
  var0=new((/2,clat,clon,nvar/),float)
  var0(:,:,:,2:nvar-1) = f->var(0:1,:,:,4:7)
  var0(:,:,:,0)=dim_sum_n(var0,3)
  var0(:,:,:,1)=var0(:,:,:,2)
  var0(:,:,:,2)=var0(:,:,:,3)+var0(:,:,:,4)+var0(:,:,:,5)

  var1 = var0
  var2 = new((/ngrid,nvar*2/),float)
  cnt=0
  do i=0,clat-1
    do j=0,clon-1
      if(.not.ismissing(var1(0,i,j,0)))then
        do k=0,nvar-1
          var2(cnt,k*2)=var1(0,i,j,k)
          var2(cnt,k*2+1)=var1(1,i,j,k)
        end do
        cnt=cnt+1
      end if
    end do
  end do
  print(cnt)

  opt = True
  opt@PrintStat = True
  yval = new((/nvar*2,5/),"float")
  do i=0,nvar*2-1
    statb = stat_dispersion(var2(:,i), opt )
    yval(i,0) = statb(24)
    yval(i,1) = statb(6)
    yval(i,2) = statb(8)
    yval(i,3) = statb(10)
    yval(i,4) = statb(25)
  end do
  print(yval(:,0))
  print(yval(:,4))

  x = (/-8, -7, -5, -4, -2, -1, 1, 2, 4, 5, 7, 8/)		
;**********************************************
; create plot
;**********************************************
  wks = gsn_open_wks("pdf",diri+"picture/anth/anth_lambda-boxplot")               ; send graphics to PNG file

  res                             = True                         ; plot mods desired
  res@vpHeightF                   = 0.3
  res@vpWidthF                    = 0.8

  res@tmXBLabelFontHeightF        = 0.02
  res@tiXAxisFontHeightF          = 0.02 
  res@tmYLLabelFontHeightF        = 0.015
  res@tiYAxisFontHeightF          = 0.015

  res@trXMinF                     = -10
  res@trXMaxF                     = 10
  res@trYMinF                     = -170
  res@trYMaxF                     = 50

  res@tmXBMode                    = "Explicit"
  res@tmXBValues                  = (/-9,-7.5,-6,-4.5,-3,-1.5,0,1.5,3,4.5,6,7.5/)
  res@tmXBLabels                  = (/"~F33~l~B~~F10~all","","~F33~l~B~0","","~F33~l~B~1+2+3","","~F33~l~B~1","","~F33~l~B~2","","~F33~l~B~3",""/) ; labels for each box
  res@tmXBMajorLengthF            = 0.0


  res@tmYLMajorOutwardLengthF     = 0.0
  res@tmYLMajorLengthF            = 0.01
  res@tmYLMinorOn                 = False

  res@tmYLMode                    = "Explicit"
  res@tmYLValues                  = fspan(-200,100,7)
  res@tmYLLabels                  = fspan(-200,100,7)
  res@tmYLMinorValues             = fspan(-200,100,31)  
  res@tiYAxisString               = "~F33~l~F21~ (W m~S~-2~N~ K~S~-1~N~)"

  res@tmXTBorderOn                = True
  res@tmYRBorderOn                = True
;**********************************************
; resources for polylines that draws the boxes
;**********************************************  
  llres                   = True			
  llres@gsLineThicknessF  = 2.5                 ; line thickness 
;**********************************************
; resources that control color and width of boxes
;**********************************************  
  opti          = True			
  opti@boxWidth = .5				; Width of box (x units)
  opti@boxColors = (/"coral2","dodgerblue3","coral2","dodgerblue3","coral2","dodgerblue3","coral2","dodgerblue3","coral2","dodgerblue3","coral2","dodgerblue3"/)  	; Color of box(es)

  plot = boxplot(wks,x,yval,opti,res,llres)	
;*****************************************************   
; Manually create and attach legend
;***************************************************** 
  res_text                    = True                  ; text mods desired
  res_text@txFontHeightF      = 0.013                 ; change text size
  res_text@txJust             = "CenterLeft"          ; text justification

  res_lines                         = True 
  res_lines@gsLineDashPattern       = 14
  xx = (/-10.,10./)
  yy = (/0.,0./)
  dum = gsn_add_polyline(wks,plot,xx,yy,res_lines)   

  xx = (/6.,7.5/)
  yy = (/-115.,-115./)
  res_lines@gsLineDashPattern = 0                    ; solid line
  res_lines@gsLineThicknessF  = 2.5                    ; line thicker
  res_lines@gsLineColor       = "coral2"                ; line color
  dum1 = gsn_add_polyline(wks,plot,xx,yy,res_lines)              ; add polyline
  dum2 = gsn_add_text(wks,plot,"JJA",8.2,-115.,res_text); add text
  
  yy = (/-145.,-145./)
  res_lines@gsLineColor       = "dodgerblue3"                             
  dum3 = gsn_add_polyline(wks,plot,xx,yy,res_lines)             
  dum4 = gsn_add_text(wks,plot,"DJF",8.2,-145.,res_text)  

  draw(wks)                                    ; boxplot does not call these
  frame(wks)                                   ; for you

end