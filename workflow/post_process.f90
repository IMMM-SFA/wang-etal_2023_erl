program postnarrmonth
use netcdf
implicit none
integer,parameter::clon=464,clat=224,ngrid=5412,bhr=24,bsea=2,dims=3,npoint=4,nvar=18,nvar2=5,nvar3=14
integer,parameter::yrs=1979,byr=20
integer,parameter::nmon=6,bmon(nmon)=(/12,1,2,6,7,8/)
integer,parameter::bday(12)=(/31,28,31,30,31,30,31,31,30,31,30,31/)
integer,parameter::plon(npoint)=(/432,299,238,21/),plat(npoint)=(/139,136,38,102/)
real,parameter::pi=3.14159265358979323846, cp=1.00464e3, lv=2.501e6, Stefan_Boltzmann=5.67e-8, Qaf=1.0
integer :: status, ncid, ncid1, ncid2, ncid3, ncid4, ncid5
integer flag,varid(5),varid1,varid2,varid3,varid4,varid5,varid6,varid7,varid8,varid9,varid10,varid11,varid12,varid13,varid14,varid15,varid16,varid17,varid18,varid19,varid20,varid21,varid22,varid23,varid24,varid25,varid26
integer start(dims),count(dims),start2(dims+1),count2(dims+1),dimids(4)
integer i,j,k,iyr,kyr,kmon,imon,iday,ihr,ilon,ilat,ivar
integer cnt_hr,cnt_dayhr,cnt_grid,cnt_mean1,cnt_mean2
real canyon_hwr(clon,clat),wtlunit_roof(clon,clat),wtroad_perv(clon,clat)
real f_roof,f_wall,f_improad,f_perroad,f_sum
real deltaTa,deltaTs,deltaTs_Ta,deltaThm_Ta,ca,cah,ca2,cah2
real TSA_U(clon,clat,bhr),TSA_U_NoFB(clon,clat,bhr),TSA_U_FB(clon,clat,bhr),THM_U(clon,clat,bhr),ra(clon,clat,bhr),rah(clon,clat,bhr),ra2(clon,clat,bhr),rah2(clon,clat,bhr),ATM_DENSITY(clon,clat,bhr),TROOF_SURFACE(clon,clat,bhr),TROOF_SURFACE2(clon,clat,bhr),TROADPERV_SURFACE(clon,clat,bhr),TROADPERV_SURFACE2(clon,clat,bhr),TROADIMPERV_SURFACE(clon,clat,bhr),TROADIMPERV_SURFACE2(clon,clat,bhr),TSUNWALL_SURFACE(clon,clat,bhr),TSUNWALL_SURFACE2(clon,clat,bhr),TSHADEWALL_SURFACE(clon,clat,bhr),TSHADEWALL_SURFACE2(clon,clat,bhr),ustar_u(clon,clat,bhr),tstar_u(clon,clat,bhr),zeta_u(clon,clat,bhr),FSDS(clon,clat,bhr),WIND(clon,clat,bhr)
real var1(nvar,bhr),var2(nvar,clon,clat),var3(nvar,clon,clat),var4(nvar,clon,clat,nmon),var5(nvar,clon,clat,bsea),mean1(nvar),mean2(nvar)
real station1(nvar3,npoint,bhr),station2(nvar3,npoint,bhr,nmon),station3(nvar3,npoint,bhr,bsea),deltaTaQaf(4,clon,clat,bhr),lambda(4,clon,clat,bhr)
real var_corr(nvar2+1,ngrid,bhr),corr1(nvar2,bhr*31),corr2(nvar2,nmon),corr3(nvar2,bsea)
character*4 cyr
character*2 cmon,cday
character*255 ext1,ext2
character*3,parameter::case1='CTL',case2='AH1'
character (len = *), parameter :: &
          varname(3) = (/'var','corr','station'/), &
          varunit(3) = (/'-','-','-'/), &
          vardesc(3) = (/'DeltaTa/Qaf and its assocaited variables in Summer and Winter','Spatial correlation coefficient between cah and deltaTa/Qaf_CLMU_fb, lambda0, ustar, tstar, WIND','DeltaTa/Qaf, cah, zeta_u, FSDS, WIND, ustar, tstar in four points'/) 
integer clon_dimid, clat_dimid, bhr_dimid, bsea_dimid, nvar_dimid, nvar2_dimid, nvar3_dimid, npoint_dimid
real lonc(clon),latc(clat)

ext1 = '/global/cscratch1/sd/wangly/archive/'
ext2 = '/global/project/projectdirs/m2702/wangly/post/process/'
call check( nf90_create(trim(ext2)//'anth.nc', nf90_clobber, ncid) )
call check( nf90_def_dim(ncid, 'lon', clon, clon_dimid) )
call check( nf90_def_dim(ncid, 'lat', clat, clat_dimid) )
call check( nf90_def_dim(ncid, 'point', npoint, npoint_dimid) )
call check( nf90_def_dim(ncid, 'varid1', nvar, nvar_dimid) )
call check( nf90_def_dim(ncid, 'varid2', nvar2, nvar2_dimid) )
call check( nf90_def_dim(ncid, 'varid3', nvar3, nvar3_dimid) )
call check( nf90_def_dim(ncid, 'season', bsea, bsea_dimid) )
call check( nf90_def_dim(ncid, 'hour', bhr, bhr_dimid) )
dimids(1) = clon_dimid
call check( nf90_def_var(ncid, 'lon', NF90_REAL, dimids(1), varid(1)) )
call check( nf90_put_att(ncid, varid(1), 'units', 'degrees_east') )
dimids(1) = clat_dimid
call check( nf90_def_var(ncid, 'lat', NF90_REAL, dimids(1), varid(2)) )
call check( nf90_put_att(ncid, varid(2), 'units', 'degrees_north') )
dimids = (/ nvar_dimid, clon_dimid, clat_dimid, bsea_dimid /)
call check( nf90_def_var(ncid, varname(1), NF90_REAL,  dimids, varid(3)) )
dimids(1:2) = (/ nvar2_dimid, bsea_dimid /)
call check( nf90_def_var(ncid, varname(2), NF90_REAL,  dimids(1:2), varid(4)) )
dimids = (/ nvar3_dimid, npoint_dimid, bhr_dimid, bsea_dimid /)
call check( nf90_def_var(ncid, varname(3), NF90_REAL,  dimids, varid(5)) )
do i=1,3
  call check( nf90_put_att(ncid, varid(i+2), 'long_name',  vardesc(i)) )
  call check( nf90_put_att(ncid, varid(i+2), 'units',      varunit(i)) )
  call check( nf90_put_att(ncid, varid(i+2), '_FillValue',    1e36))
  call check( nf90_put_att(ncid, varid(i+2), 'missing_value', 1e36))
end do
call check( nf90_put_att(ncid, nf90_global, 'period',  '1980-1999'   ) )
call check( nf90_put_att(ncid, nf90_global, 'source',  'CLM outputs' ) )
call check( nf90_put_att(ncid, nf90_global, 'history', 'Created by Linying Wang, BU, 2022-05') )
call check( nf90_enddef(ncid) )

call check( nf90_open(trim(ext2)//'thermal_urban_CONUS.nc', NF90_NOWRITE, ncid1) )
call check( nf90_inq_varid(ncid1, 'canyon_hwr', varid1) )
call check( nf90_get_var(ncid1, varid1, canyon_hwr) )
call check( nf90_inq_varid(ncid1, 'wtlunit_roof', varid2) )
call check( nf90_get_var(ncid1, varid2, wtlunit_roof) )
call check( nf90_inq_varid(ncid1, 'wtroad_perv', varid3) )
call check( nf90_get_var(ncid1, varid3, wtroad_perv) )
call check( nf90_close(ncid1) )

var5=0.
corr3=0.
station3=0.
mean1=0.
cnt_mean1=0
cnt_grid=0
do kyr=yrs+1,yrs+byr
  iyr=kyr-yrs
  mean2=0.
  cnt_mean2=0
  do kmon=1,6
    imon=bmon(kmon)
    print*,kyr,imon
    var3=0.
    station1=0.
    cnt_dayhr=0
    do iday=1,bday(imon)
      write(cyr,'(i4)') kyr
      write(cmon,'(i2.2)') imon
      write(cday,'(i2.2)') iday
      call check( nf90_open(trim(ext1)//'urban_I2000Clm50SpGs_CONUS_NLDAS2_'//trim(case1)//'/lnd/hist/urban_I2000Clm50SpGs_CONUS_NLDAS2_'//trim(case1)//'.clm2.h0.'//cyr//'-'//cmon//'-'//cday//'-00000.nc', NF90_NOWRITE, ncid1) )
      call check( nf90_open(trim(ext1)//'urban_I2000Clm50SpGs_CONUS_NLDAS2_'//trim(case2)//'/lnd/hist/urban_I2000Clm50SpGs_CONUS_NLDAS2_'//trim(case2)//'.clm2.h0.'//cyr//'-'//cmon//'-'//cday//'-00000.nc', NF90_NOWRITE, ncid2) )
      call check( nf90_open(trim(ext1)//'urban_I2000Clm50SpGs_CONUS_NLDAS2_'//trim(case1)//'/lnd/hist/urban_I2000Clm50SpGs_CONUS_NLDAS2_'//trim(case1)//'.clm2.h2.'//cyr//'-'//cmon//'-'//cday//'-00000.nc', NF90_NOWRITE, ncid3) )
      call check( nf90_open(trim(ext1)//'urban_I2000Clm50SpGs_CONUS_NLDAS2_'//trim(case2)//'/lnd/hist/urban_I2000Clm50SpGs_CONUS_NLDAS2_'//trim(case2)//'.clm2.h2.'//cyr//'-'//cmon//'-'//cday//'-00000.nc', NF90_NOWRITE, ncid4) )
      call check( nf90_open(trim(ext1)//'urban_I2000Clm50SpGs_CONUS_NLDAS2_'//trim(case1)//'/lnd/hist/urban_I2000Clm50SpGs_CONUS_NLDAS2_'//trim(case1)//'.clm2.h3.'//cyr//'-'//cmon//'-'//cday//'-00000.nc', NF90_NOWRITE, ncid5) )
      call check( nf90_inq_varid(ncid1, 'lon', varid1) )
      call check( nf90_get_var(ncid1, varid1, lonc) )
      call check( nf90_inq_varid(ncid1, 'lat', varid2) )
      call check( nf90_get_var(ncid1, varid2, latc) )
      start=(/1,1,1/); count=(/clon,clat,bhr/)
      call check( nf90_inq_varid(ncid1, 'TSA_U', varid3) )
      call check( nf90_get_var(ncid1, varid3, TSA_U, start, count) )
      call check( nf90_inq_varid(ncid1, 'TSA_U2', varid4) )
      call check( nf90_get_var(ncid1, varid4, TSA_U_NoFB, start, count) )
      call check( nf90_inq_varid(ncid2, 'TSA_U', varid5) )
      call check( nf90_get_var(ncid2, varid5, TSA_U_FB, start, count) )
      call check( nf90_inq_varid(ncid1, 'THM_U', varid6) )
      call check( nf90_get_var(ncid1, varid6, THM_U, start, count) )
      call check( nf90_inq_varid(ncid1, 'RA_CANYON', varid7) )
      call check( nf90_get_var(ncid1, varid7, ra, start, count) )
      call check( nf90_inq_varid(ncid1, 'RA_CANYON2', varid8) )
      call check( nf90_get_var(ncid1, varid8, rah, start, count) )
      call check( nf90_inq_varid(ncid2, 'RA_CANYON', varid9) )
      call check( nf90_get_var(ncid2, varid9, ra2, start, count) )
      call check( nf90_inq_varid(ncid2, 'RA_CANYON2', varid10) )
      call check( nf90_get_var(ncid2, varid10, rah2, start, count) )
      call check( nf90_inq_varid(ncid1, 'ATM_DENSITY', varid11) )
      call check( nf90_get_var(ncid1, varid11, ATM_DENSITY, start, count) )
      call check( nf90_inq_varid(ncid1, 'TROOF_SURFACE', varid12) )
      call check( nf90_get_var(ncid1, varid12, TROOF_SURFACE, start, count) )
      call check( nf90_inq_varid(ncid1, 'TROADPERV_SURFACE', varid13) )
      call check( nf90_get_var(ncid1, varid13, TROADPERV_SURFACE, start, count) )
      call check( nf90_inq_varid(ncid1, 'TROADIMPERV_SURFACE', varid14) )
      call check( nf90_get_var(ncid1, varid14, TROADIMPERV_SURFACE, start, count) )
      call check( nf90_inq_varid(ncid1, 'TSUNWALL_SURFACE', varid15) )
      call check( nf90_get_var(ncid1, varid15, TSUNWALL_SURFACE, start, count) )
      call check( nf90_inq_varid(ncid1, 'TSHADEWALL_SURFACE', varid16) )
      call check( nf90_get_var(ncid1, varid16, TSHADEWALL_SURFACE, start, count) )
      call check( nf90_inq_varid(ncid2, 'TROOF_SURFACE', varid17) )
      call check( nf90_get_var(ncid2, varid17, TROOF_SURFACE2, start, count) )
      call check( nf90_inq_varid(ncid2, 'TROADPERV_SURFACE', varid18) )
      call check( nf90_get_var(ncid2, varid18, TROADPERV_SURFACE2, start, count) )
      call check( nf90_inq_varid(ncid2, 'TROADIMPERV_SURFACE', varid19) )
      call check( nf90_get_var(ncid2, varid19, TROADIMPERV_SURFACE2, start, count) )
      call check( nf90_inq_varid(ncid2, 'TSUNWALL_SURFACE', varid20) )
      call check( nf90_get_var(ncid2, varid20, TSUNWALL_SURFACE2, start, count) )
      call check( nf90_inq_varid(ncid2, 'TSHADEWALL_SURFACE', varid21) )
      call check( nf90_get_var(ncid2, varid21, TSHADEWALL_SURFACE2, start, count) )
      call check( nf90_inq_varid(ncid3, 'ustar_u', varid22) )
      call check( nf90_get_var(ncid3, varid22, ustar_u, start, count) )
      call check( nf90_inq_varid(ncid3, 'tstar_u', varid23) )
      call check( nf90_get_var(ncid3, varid23, tstar_u, start, count) )
      call check( nf90_inq_varid(ncid3, 'zeta_u', varid24) )
      call check( nf90_get_var(ncid3, varid24, zeta_u, start, count) )
      call check( nf90_inq_varid(ncid5, 'FSDS', varid25) )
      call check( nf90_get_var(ncid5, varid25, FSDS, start, count) )
      call check( nf90_inq_varid(ncid5, 'WIND', varid26) )
      call check( nf90_get_var(ncid5, varid26, WIND, start, count) )
      call check( nf90_close(ncid1) )
      call check( nf90_close(ncid2) )
      call check( nf90_close(ncid3) )
      call check( nf90_close(ncid4) )
      call check( nf90_close(ncid5) )

      var2=0.
      cnt_grid=0
      do ilat=1,clat
        do ilon=1,clon
          if(TSA_U(ilon,ilat,1)<1e30)then
            f_roof = wtlunit_roof(ilon,ilat)
            f_perroad = wtroad_perv(ilon,ilat)*(1.-wtlunit_roof(ilon,ilat))
            f_improad = (1.-wtroad_perv(ilon,ilat))*(1.-wtlunit_roof(ilon,ilat))
            f_wall = canyon_hwr(ilon,ilat)*(1.-wtlunit_roof(ilon,ilat))
            f_sum = f_roof+2.*f_wall+f_improad+f_perroad        
            cnt_hr = 0
            do ihr=1,bhr
              ca = 1./ra(ilon,ilat,ihr)
              cah = 1./rah(ilon,ilat,ihr)
              ca2 = 1./ra2(ilon,ilat,ihr)
              cah2 = 1./rah2(ilon,ilat,ihr)
              deltaThm_Ta = THM_U(ilon,ilat,ihr)-TSA_U(ilon,ilat,ihr) ! CTL
              deltaTs_Ta = f_roof*TROOF_SURFACE(ilon,ilat,ihr)+f_wall*TSUNWALL_SURFACE(ilon,ilat,ihr)+f_wall*TSHADEWALL_SURFACE(ilon,ilat,ihr)+f_improad*TROADIMPERV_SURFACE(ilon,ilat,ihr)+f_perroad*TROADPERV_SURFACE(ilon,ilat,ihr)-f_sum*TSA_U(ilon,ilat,ihr) ! CTL
              deltaTa = TSA_U_FB(ilon,ilat,ihr)-TSA_U(ilon,ilat,ihr) ! AH1 - CTL
              deltaTs = f_roof*(TROOF_SURFACE2(ilon,ilat,ihr)-TROOF_SURFACE(ilon,ilat,ihr))+f_wall*(TSUNWALL_SURFACE2(ilon,ilat,ihr)-TSUNWALL_SURFACE(ilon,ilat,ihr))+f_wall*(TSHADEWALL_SURFACE2(ilon,ilat,ihr)-TSHADEWALL_SURFACE(ilon,ilat,ihr))+f_improad*(TROADIMPERV_SURFACE2(ilon,ilat,ihr)-TROADIMPERV_SURFACE(ilon,ilat,ihr))+f_perroad*(TROADPERV_SURFACE2(ilon,ilat,ihr)-TROADPERV_SURFACE(ilon,ilat,ihr)) ! AH1 - CTL
              if(deltaTa.ne.0)then   
                var1(5,ihr) = -ATM_DENSITY(ilon,ilat,ihr)*cp*(ca*f_sum+cah)                  ! lambda0
                var1(6,ihr) = ATM_DENSITY(ilon,ilat,ihr)*cp*(ca*(deltaTs/deltaTa))           ! lambda1
                var1(7,ihr) = ATM_DENSITY(ilon,ilat,ihr)*cp*(deltaThm_Ta*(cah2-cah)/deltaTa) ! lambda2
                var1(8,ihr) = ATM_DENSITY(ilon,ilat,ihr)*cp*(deltaTs_Ta*(ca2-ca)/deltaTa)    ! lambda3
                var1(1,ihr) = (TSA_U_NoFB(ilon,ilat,ihr)-TSA_U(ilon,ilat,ihr))/1. ! deltaTa/Qaf_CLMU_nofb
                var1(2,ihr) = deltaTa/Qaf                                         ! deltaTa/Qaf_CLMU_fb
                var1(3,ihr) = -1./var1(5,ihr)                                     ! deltaTa/Qaf_CAEB_nofb
                var1(4,ihr) = -1./sum(var1(5:8,ihr))                              ! deltaTa/Qaf_CAEB_fb
                var1(9,ihr) = cah
                var1(10,ihr) = cah2
                var1(11,ihr) = ca
                var1(12,ihr) = ca2
                var1(13,ihr) = FSDS(ilon,ilat,ihr)
                var1(14,ihr) = WIND(ilon,ilat,ihr)
                var1(15,ihr) = deltaTs/deltaTa
                var1(16,ihr) = (cah2-cah)/deltaTa
                var1(17,ihr) = (var1(2,ihr)-var1(1,ihr))/var1(1,ihr)*100      ! Feedback_CLMU
                var1(18,ihr) = -(sum(var1(6:8,ihr)))/(sum(var1(5:8,ihr)))*100 ! Feedback_CAEB
                deltaTaQaf(:,ilon,ilat,ihr) = var1(1:4,ihr)
                lambda(:,ilon,ilat,ihr) = var1(5:8,ihr)
                var2(:,ilon,ilat) = var2(:,ilon,ilat)+var1(:,ihr)
                cnt_hr = cnt_hr+1
              end if            
            end do ! End hour cycle
            if(cnt_hr.ne.0) var2(:,ilon,ilat) = var2(:,ilon,ilat)/cnt_hr
            cnt_mean1 = cnt_mean1+1
            cnt_mean2 = cnt_mean2+1
            do ivar=1,nvar
              mean1(ivar) = mean1(ivar)+var2(ivar,ilon,ilat)
              mean2(ivar) = mean2(ivar)+var2(ivar,ilon,ilat)
            end do
            cnt_grid = cnt_grid+1
            var_corr(1,cnt_grid,:) = var1(2,:) ! deltaTa/Qaf_CLMU_fb
            var_corr(2,cnt_grid,:) = var1(5,:) ! lambda0
            var_corr(3,cnt_grid,:) = ustar_u(ilon,ilat,:)
            var_corr(4,cnt_grid,:) = tstar_u(ilon,ilat,:)
            var_corr(5,cnt_grid,:) = WIND(ilon,ilat,:)
            var_corr(6,cnt_grid,:) = 1./rah(ilon,ilat,:)
          end if
        end do ! End lat cycle
      end do ! End lon cycle
      var3 = var3+var2
      do ihr=1,bhr
        cnt_dayhr=cnt_dayhr+1
        do ivar=1,nvar2
          call sub_correlation(ngrid,var_corr(ivar,:,ihr),var_corr(6,:,ihr),corr1(ivar,cnt_dayhr))
        end do
      end do      
      do i=1,npoint
        station1(1:4,i,:) = station1(1:4,i,:) + deltaTaQaf(:,plon(i),plat(i),:)
        station1(5,i,:) = station1(5,i,:) + 1/rah(plon(i),plat(i),:)
        station1(6,i,:) = station1(6,i,:) + zeta_u(plon(i),plat(i),:)
        station1(7,i,:) = station1(7,i,:) + FSDS(plon(i),plat(i),:)
        station1(9,i,:) = station1(9,i,:) + ustar_u(plon(i),plat(i),:)
        station1(10,i,:) = station1(10,i,:) + tstar_u(plon(i),plat(i),:)
        station1(11:14,i,:) = station1(11:14,i,:) + lambda(:,plon(i),plat(i),:)
      end do
    end do ! End day cycle
    var4(:,:,:,kmon) = var3/bday(imon)
    do ivar=1,nvar2
      corr2(ivar,kmon)=sum(corr1(ivar,1:cnt_dayhr))/cnt_dayhr
    end do    
    station2(:,:,:,kmon)=station1/bday(imon)
  end do ! End month cycle
  var5(:,:,:,1) = var5(:,:,:,1)+(var4(:,:,:,4)+var4(:,:,:,5)+var4(:,:,:,6))/3 ! JJA
  var5(:,:,:,2) = var5(:,:,:,2)+(var4(:,:,:,1)+var4(:,:,:,2)+var4(:,:,:,3))/3 ! DJF
  corr3(:,1) = corr3(:,1)+(corr2(:,4)+corr2(:,5)+corr2(:,6))/3
  corr3(:,2) = corr3(:,2)+(corr2(:,1)+corr2(:,2)+corr2(:,3))/3
  station3(:,:,:,1) = station3(:,:,:,1)+(station2(:,:,:,4)+station2(:,:,:,5)+station2(:,:,:,6))/3
  station3(:,:,:,2) = station3(:,:,:,2)+(station2(:,:,:,1)+station2(:,:,:,2)+station2(:,:,:,3))/3
  mean2=mean2/cnt_mean2
  print*,mean2
end do ! End year cycle
var5 = var5/byr
corr3 = corr3/byr
station3 = station3/byr
mean1=mean1/cnt_mean1
print*,mean1
write(*,"(A11,5F8.2)"),'corr JJA',corr3(:,1)
write(*,"(A11,5F8.2)"),'corr DJF',corr3(:,2)

do ilat=1,clat
  do ilon=1,clon
    if(TSA_U(ilon,ilat,1)>1e30)then
       var5(:,ilon,ilat,:)=1e36
    end if
  end do
end do 

call check( nf90_put_var(ncid, varid(1), lonc) )
call check( nf90_put_var(ncid, varid(2), latc) )
call check( nf90_put_var(ncid, varid(3), var5) )
call check( nf90_put_var(ncid, varid(4), corr3) )
call check( nf90_put_var(ncid, varid(5), station3) )
call check( nf90_close(ncid) )
print*,'ok'


contains
  subroutine check(status)
  integer, intent ( in) :: status
  if(status /= nf90_noerr) then
     print *, trim(nf90_strerror(status))
     stop "Stopped"
  end if
  end subroutine check
end

subroutine rdplot(dat,no,io,nrec,finame)
integer no,io,nrec
real  dat(no)
character(len=*)::  finame
open (io,status='old',file=trim(finame)&
      ,form='unformatted',access='direct',recl=no*1)
read (io,rec=nrec) (dat(i),i=1,no)
close(io)
end

subroutine wrplot(dat,no,io,nrec,finame)
integer no,io,nrec
real  dat(no)
character(len=*)::  finame
open (io,file=trim(finame)&
      ,form='unformatted',access='direct',recl=no*1)
write (io,rec=nrec) (dat(i),i=1,no)
close(io)
end

subroutine sub_correlation(n,x,y,r)
integer,intent(in)::n            
real,dimension(n),intent(in)::x,y
real,intent(out)::r             
real,intrinsic::sqrt,float     
real::ave1,ave2,var1,var2,tmp 
integer::i                   
                               
ave1=0.0; ave2=0.0; var1=0.0; var2=0.0  
do i=1,n                               
   ave1=ave1+x(i)/float(n)            
   ave2=ave2+y(i)/float(n)           
enddo                               
do i=1,n                          
   var1=var1+(x(i)-ave1)**2      
   var2=var2+(y(i)-ave2)**2     
enddo                          
tmp=0.0                       
do i=1,n                     
   tmp=tmp+(x(i)-ave1)*(y(i)-ave2)      
enddo                                  
r=tmp/sqrt(var1*var2)                 
end      
