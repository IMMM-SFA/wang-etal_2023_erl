;************************************************
begin
;************************************************
  nvar = 8
  N = nvar
  time = 24
  atime = (/4,5,5,7/)

  varname = (/"~F10~SW~B~atm~N~ (~F21~W m~S~-2~N~)","~F10~Wind~B~atm~N~ (~F21~m s~S~-1~N~)","~F10~u~B~*~N~ (~F21~m s~S~-1~N~)","~F8~q~B~*~N~ (~F21~K~N~)"/)
  unitname = (/"Unit: W m~S~-2","Unit: m s~S~-1","Unit: m s~S~-1","Unit: K"/)
  figname = (/"(a) ","(b) ","(c) ","(d) ","(e) ","(f) ","(g) ","(h) "/)
  seaname = (/"JJA","DJF","ANN"/)

  diri = "/Users/wly/post/"
  f = addfile(diri+"process/anth/anth.nc","r")
  var0 = new((/2,4,25,4/),float)
  var0(:,0,0:23,:) = f->station(0:1,:,:,6) ;sea=3, hour=24, point=4, varid3=4
  var0(:,1,0:23,:) = f->station(0:1,:,:,7)
  var0(:,2,0:23,:) = f->station(0:1,:,:,8)
  var0(:,3,0:23,:) = f->station(0:1,:,:,9)

  var1 = new((/2,4,4,25/),float)
  do i=0,3
    var1(:,:,i,0:23-atime(i)) = var0(:,:,atime(i):23,i)
    var1(:,:,i,24-atime(i):24) = var0(:,:,0:atime(i),i)
  end do

  ymin = (/0.,1,0.1,-0.6/)
  ymax = (/1000.,6,1,0.2/)

  xhour = ispan(0,time,1)
;************************************************
 wks  = gsn_open_wks("pdf",diri+"picture/anth/station3")
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
 res@tiYAxisString                 = ""

 res@trXMinF                       = 0
 res@trXMaxF                       = time

 res@xyDashPattern                 = (/0,0,0,0/)
 res@xyLineThicknesses             = (/2,2,2,2/)
 res@xyLineColors                  = (/"cornflowerblue","forestgreen","orange","Brown"/)

;  res@xyMarkLineMode                = "MarkLines"
;  res@xyMarkers                     = (/16,16,16,16/)
;  res@xyMarkerColors                = (/"blue","forestgreen","orange","red"/);(/4,19,13,2/)

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
  res@pmLegendParallelPosF          = 0.23                ; move units right
  res@pmLegendOrthogonalPosF        = -0.94              ; move units down
  res@pmLegendWidthF                = 0.12
  res@pmLegendHeightF               = 0.21
  res@lgPerimOn                     = False                ; turn off/on box around
  res@lgLabelFontHeightF            = 0.025
  res@xyExplicitLegendLabels = (/"Boston","Chicago","Houston","San Francisco"/)

  do i=0,1
    do j=0,3
      if((j*2+i).eq.0) then
        res@pmLegendDisplayMode     = "Always"
      else
        res@pmLegendDisplayMode     = "Never"
      end if

      if(j.eq.3)then  
        res@tiXAxisString           = "Local time of day (h)"
        res@tmYLPrecision           = 1
      else
        res@tiXAxisString           = ""
        if(j.eq.1)then  
          res@tmYLPrecision         = 0
        else
          res@tmYLPrecision         = 2
        end if 
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
  res_text@txFontHeightF      = 0.017                 ; change text size
  res_text@txJust             = "CenterLeft"          ; text justification
  gsn_text_ndc(wks,"JJA",0.272,0.96,res_text)
  gsn_text_ndc(wks,"DJF",0.769,0.96,res_text) 
;************************************************
; create panel
;************************************************
  resP                              = True
  resP@gsnFrame                     = False                  ; don't advance panel plot
  gsn_panel(wks,plot,(/4,2/),resP)
end 

