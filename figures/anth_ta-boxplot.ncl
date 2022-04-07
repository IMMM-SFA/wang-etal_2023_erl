;************************************************
begin
;************************************************
  nvar = 8
  nsea = 2
  N = 2
  clat = 224
  clon = 464
  ngrid = 5412

  figname = (/"(a) CLMU","(b) CAEB"/)

  diri = "/Users/wly/post/"
  f1 = addfile(diri+"process/anth/anth.nc","r")
  f2 = addfile(diri+"process/anth/anth2.nc","r")
  f3 = addfile(diri+"process/anth/anth3.nc","r")
  var0 = f1->var(:,:,:,0:nvar-1)
  do i=0,1
    var0(i,:,:,0) = f1->var(0,:,:,i*2)
    var0(i,:,:,1) = f1->var(1,:,:,i*2)
    var0(i,:,:,2) = f1->var(0,:,:,i*2+1)
    var0(i,:,:,3) = f1->var(1,:,:,i*2+1)
    var0(i,:,:,4) = f2->var(0,:,:,i*2+1)
    var0(i,:,:,5) = f2->var(1,:,:,i*2+1)
    var0(i,:,:,6) = f3->var(0,:,:,i*2+1)
    var0(i,:,:,7) = f3->var(1,:,:,i*2+1)
  end do 
  var1 = var0

  var2 = new((/nsea,ngrid,nvar/),float)
  cnt=0
  do i=0,clat-1
    do j=0,clon-1
      if(.not.ismissing(var1(0,i,j,0)))then
        var2(:,cnt,:)=var1(:,i,j,:)
        cnt=cnt+1
      end if
    end do
  end do
  ;sprint(cnt)

  opt = True
  opt@PrintStat = False
  yval = new((/nsea,nvar,5/),"float")
  do j=0,nsea-1
    do i=0,nvar-1
      statb = stat_dispersion(var2(j,:,i), opt )
      yval(j,i,0) = statb(24)
      yval(j,i,1) = statb(6)
      yval(j,i,2) = statb(8)
      yval(j,i,3) = statb(10)
      yval(j,i,4) = statb(25)
    end do
  end do
  ;print(yval(:,0))
  ;print(yval(:,4))

  x = (/-5, -4, -2, -1, 1, 2, 4, 5/)
;**********************************************
; create plot
;**********************************************
  wks = gsn_open_wks("pdf",diri+"picture/anth/anth_ta-boxplot")
  plot = new(N,graphic)
  dum = new(N,graphic)

  res                             = True  
  res@vpHeightF                   = 0.3  
  res@vpWidthF                    = 0.8

  res@tmXBLabelFontHeightF        = 0.018
  res@tiXAxisFontHeightF          = 0.018
  res@tmYLLabelFontHeightF        = 0.018
  res@tiYAxisFontHeightF          = 0.018

  res@trXMinF                     = -7
  res@trXMaxF                     = 7
  res@trYMinF                     = -0.03
  res@trYMaxF                     = 0.06

  res@tmXBMode                    = "Explicit"
  res@tmXBValues                  = (/-6,-4.5,-3,-1.5,0,1.5,3,4.5/)
  res@tmXBLabels                  = (/"CTL","","AH1","","AH2","","AH3",""/) ; labels for each box
  res@tmXBMajorLengthF            = 0.0

  res@tiYAxisString               = "~F8~D~F10~T~B~a~N~/~F8~D~F10~Q~B~AH~N~ ~F21~(K (W ~N~m~S~-2~N~)~S~-1~N~)"
  res@tmYLPrecision               = 2

  res@tmXTBorderOn                = True
  res@tmYRBorderOn                = True
;**********************************************
; resources for polylines that draws the boxes
;**********************************************  
  llres                   = True			
  llres@gsLineThicknessF  = 3.5                 ; line thickness 
;**********************************************
; resources that control color and width of boxes
;**********************************************  
  opti          = True			
  opti@boxWidth = .5				; Width of box (x units)
  opti@boxColors = (/"coral2","dodgerblue3","coral2","dodgerblue3","coral2","dodgerblue3","coral2","dodgerblue3"/)  	; Color of box(es)
;*****************************************************   
; Manually create and attach legend
;***************************************************** 
  res_text                          = True                  ; text mods desired
  res_text@txFontHeightF            = 0.019                 ; change text size
  res_text@txJust                   = "CenterLeft"          ; text justification
  gsn_text_ndc(wks,figname(0),.15,.89,res_text)
  gsn_text_ndc(wks,figname(1),.15,.46,res_text)
  res_text@txFontHeightF            = 0.015                 ; change text size

  res_lines                         = True 
  xx = (/-7.,7./)
  yy = (/0.01,0.01/)
  res_lines@gsLineDashPattern       = 14
  res_lines@gsLineThicknessF        = 3. 
  res_lines@gsLineColor             = "black" 

  do i=0,1
    plot(i) = boxplot(wks,x,yval(i,:,:),opti,res,llres)	 
    dum(i) = gsn_add_polyline(wks,plot(i),xx,yy,res_lines)   
  end do

  xx = (/-5.5,-4.5/)
  yy = (/0.047,0.047/)
  res_lines@gsLineDashPattern       = 0 
  res_lines@gsLineThicknessF        = 3
  res_lines@gsLineColor             = "coral2"  
  dum1 = gsn_add_polyline(wks,plot(0),xx,yy,res_lines)
  dum2 = gsn_add_text(wks,plot(0),"JJA",-4,0.047,res_text)
  
  yy = (/0.035,0.035/)
  res_lines@gsLineColor             = "dodgerblue3"                             
  dum3 = gsn_add_polyline(wks,plot(0),xx,yy,res_lines)             
  dum4 = gsn_add_text(wks,plot(0),"DJF",-4,0.035,res_text)   
;***********************************************
; the function boxplot will accept three different
; resource lists. In this default example, we set
; two of them to False.
;**********************************************
;************************************************
; create panel
;************************************************
  resP                              = True
  resP@gsnFrame                     = False 
  gsn_panel(wks,plot,(/2,1/),resP)
  frame(wks)       
end