;************************************************
begin
;************************************************
  nvar = 2
  N = 4
  time = 24
  atime = (/4,5,5,7/)

  varname = (/"~F10~c~B~a~N~ (~F21~m s~S~-1~N~)"," ~F8~z~N~ (~F21~unitless)"/)
  unitname = (/"m s~S~-1","unitless"/)
  figname = (/"(a)","(b)","(c)","(d)"/)
  seaname = (/"JJA","DJF"/)

  diri = "/Users/wly/post/"
  f = addfile(diri+"process/anth/anth.nc","r")
  var0 = new((/2,nvar,25,4/),float)
  var0(:,0,0:23,:) = f->station(0:1,:,:,4) ;sea=3, hour=24, point=4, varid3=4
  var0(:,1,0:23,:) = f->station(0:1,:,:,5)

  var1 = new((/2,nvar,4,25/),float)
  do i=0,3
    var1(:,:,i,0:23-atime(i)) = var0(:,:,atime(i):23,i)
    var1(:,:,i,24-atime(i):24) = var0(:,:,0:atime(i),i)
  end do

  ymin = (/0,-0.8/)
  ymax = (/0.15,0.6/)

  xhour = ispan(0,time,1)
;************************************************
 wks  = gsn_open_wks("pdf",diri+"picture/anth/station2")
 plot = new(N,graphic)

 res                               = True        ; plot mods desired
 res@gsnDraw                       = False       ; don't draw yet
 res@gsnFrame                      = False       ; don't advance frame yet

 res@vpHeightF                     = 0.3
 res@vpWidthF                      = 0.8

 res@tmXBLabelFontHeightF          = 0.025
 res@tmYLLabelFontHeightF          = 0.025
 res@gsnLeftStringFontHeightF      = 0.028
 res@tiYAxisFontHeightF            = 0.028
 ;res@tiYAxisString                 = ""
 res@gsnRightString                = ""

 res@trXMinF                       = 0
 res@trXMaxF                       = time

 ;res@xyLineDashSegLenF             = (/0,0,0,0/)
 res@xyDashPattern                 = (/0,0,0,0/)
 res@xyLineThicknesses             = (/2,2,2,2/)
 res@xyLineColors                  = (/"cornflowerblue","forestgreen","orange","Brown"/);(/"NavyBlue","Seagreen","Brown","Magenta4"/)

;  res@xyMarkLineMode                = "MarkLines"
;  res@xyMarkers                     = (/16,16,16,16/)
;  res@xyMarkerColors                = (/"cornflowerblue","palegreen4","darkorange2","orchid3"/)

 res@tmXBOn                        = True
 res@tmXTOn                        = False
 res@tmYROn                        = False
 res@tmXBLabelsOn                  = True
 res@tmXBMode                      = "Explicit"
 res@tmXBValues                    = ispan(0,time,6)
 res@tmXBLabels                    = ispan(0,time,6)
 ;res@tmXBMinorValues               = ispan(0,time,1)

 res@tmXBMajorOutwardLengthF       = 0.0
 res@tmXBMajorLengthF              = 0.01
 res@tmYLMajorOutwardLengthF       = 0.0
 ;res@tmYLMajorThicknessF           = 1.0
 res@tmYLMajorLengthF              = 0.01

 res@tmYLMinorOn                   = False
 res@tmYLAutoPrecision             = False
 res@tmYLPrecision                 = 2

 res@gsnXRefLineDashPatterns       = (/14/)
 res@gsnXRefLine                   = (/12/)  
 res@gsnYRefLineDashPattern        = 14
 res@gsnYRefLine                   = 0 

  res@pmLegendDisplayMode           = "Always"            ; turn on legend
  res@pmLegendSide                  = "Top"               ; Change location of 
  res@pmLegendParallelPosF          = 0.7                ; move units right
  res@pmLegendOrthogonalPosF        = -1.12              ; move units down
  res@pmLegendWidthF                = 0.1
  res@pmLegendHeightF               = 0.18
  res@lgPerimOn                     = False                ; turn off/on box around
  res@lgLabelFontHeightF            = 0.02
  res@xyExplicitLegendLabels = (/"Boston","Chicago","Houston","San Francisco"/)

  do i=0,1
    do j=0,1
      if((j*2+i).eq.0) then
        res@pmLegendDisplayMode     = "Always"
      else
        res@pmLegendDisplayMode     = "Never"
      end if
      if(j.eq.1)then  
        res@tiXAxisString           = "Local time of day (h)"
        res@tmYLPrecision           = 1
      else
        res@tiXAxisString           = ""
        res@tmYLPrecision           = 2
      end if    
      res@tiYAxisString             = varname(j)
      res@gsnLeftString             = figname(i+j*2);+varname(j)
      res@trYMinF                   = ymin(j)
      res@trYMaxF                   = ymax(j)
      plot(i+j*2)  = gsn_csm_xy (wks,xhour,var1(i,j,:,:),res)
    end do
  end do
;***************************************************** 
  res_text                    = True                  ; text mods desired
  res_text@txFontHeightF      = 0.013                 ; change text size
  res_text@txJust             = "CenterLeft"          ; text justification
  gsn_text_ndc(wks,"JJA",0.272,0.735,res_text)
  gsn_text_ndc(wks,"DJF",0.769,0.735,res_text) 
;************************************************
; create panel
;************************************************
  resP                              = True
  resP@gsnFrame                     = False                  ; don't advance panel plot
  gsn_panel(wks,plot,(/2,2/),resP)
end 

