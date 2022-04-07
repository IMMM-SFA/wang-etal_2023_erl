;************************************************
begin
;************************************************
  nvar = 8
  N = 4
  time = 24
  atime = (/4,5,5,7/)

  varname = (/"~F10~(~F8~D~F10~T~B~a~N~/~F8~D~F10~Q~B~AH~N~)~B~nofd","~F10~(~F8~D~F10~T~B~a~N~/~F8~D~F10~Q~B~AH~N~)~B~fd"/)
  unitname = (/"K","K","m s~S~-1","unitless"/)
  figname = (/"(a) ","(b) ","(c) ","(d) "/)
  seaname = (/"JJA","DJF"/)

  diri = "/Users/wly/post/"
  f = addfile(diri+"process/anth/anth.nc","r")
  var0 = new((/2,2,25,4/),float)                          ; sea=2, varid=2; hour=24, point=4 
  var0(:,0,0:23,:) = f->station(0:1,:,:,0)               
  var0(:,1,0:23,:) = f->station(0:1,:,:,1)

  var1 = new((/2,2,4,25/),float)
  do i=0,3
    var1(:,:,i,0:23-atime(i)) = var0(:,:,atime(i):23,i)   ; sea=2, varid=2; point=4, hour=24
    var1(:,:,i,24-atime(i):24) = var0(:,:,0:atime(i),i)
  end do

  var2 = dim_max(var1)
  var3 = new((/2,4/),float)
  var3 = (var2(:,1,:)-var2(:,0,:))/var2(:,0,:)*100.
  var3 = decimalPlaces(var3,1,True)
  print(var3)
  var2 = decimalPlaces(var2,3,True)
  print(var2)

  ymin = (/0.,0,0,-0.8/)
  ymax = (/0.04,0.04,0.15,0.6/)
  
  xhour = ispan(0,time,1)
;************************************************
  wks  = gsn_open_wks("pdf",diri+"picture/anth/station1")
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
  res@gsnRightString                = ""

  res@trXMinF                       = 0
  res@trXMaxF                       = time

  res@xyDashPattern                 = (/0,0,0,0/)
  res@xyLineThicknesses             = (/2,2,2,2/)
  res@xyLineColors                  = (/"cornflowerblue","forestgreen","orange","Brown"/)

  res@tmXBOn                        = True
  res@tmXTOn                        = False
  res@tmYROn                        = False
  res@tmXBLabelsOn                  = True
  res@tmXBMode                      = "Explicit"
  res@tmXBValues                    = ispan(0,time,6)
  res@tmXBLabels                    = ispan(0,time,6)

  res@tmXBMajorOutwardLengthF       = 0.0
  res@tmXBMajorLengthF              = 0.01
  res@tmYLMajorOutwardLengthF       = 0.0
  res@tmYLMajorLengthF              = 0.01

  res@tmYLMinorOn                   = False
  res@tmYLAutoPrecision             = False
  res@tmYLPrecision                 = 1

  res@gsnXRefLineDashPatterns       = (/14/)
  res@gsnXRefLine                   = (/12/)  
  res@gsnYRefLineDashPattern        = 14
  res@gsnYRefLine                   = 0 

  res@pmLegendDisplayMode           = "Always"            ; turn on legend
  res@pmLegendSide                  = "Top"               ; Change location of 
  res@pmLegendParallelPosF          = 0.79                ; move units right
  res@pmLegendOrthogonalPosF        = -0.88               ; move units down
  res@pmLegendWidthF                = 0.1
  res@pmLegendHeightF               = 0.18
  res@lgPerimOn                     = False               ; turn off/on box around
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
      else
        res@tiXAxisString           = ""
      end if     
      res@tiYAxisString             = varname(j)
      res@gsnLeftString             = figname(j*2+i);+varname(j)
      res@trYMinF                   = ymin(j)
      res@trYMaxF                   = ymax(j)
      plot(j*2+i)  = gsn_csm_xy (wks,xhour,var1(i,j,:,:),res)
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
  resP@gsnFrame                     = False 
  gsn_panel(wks,plot,(/2,2/),resP)
end 

