


begin

   ;;;; Set up NetCDF4 Setup

   setfileoption("nc", "FileStructure", "Advanced")
   setfileoption("nc", "Format",        "NetCDF4")

   ;;;; Target Labels

   location_name_array = (/ "Rapid City, SD", \
                            "Brookings, SD",  \
                            "Phillip, SD"     /)

   location_abbr_array = (/ "KRAP", \
                            "KBKX", \
                            "KPHP"  /)

   ;;;; Target Latitudes and Longitudes

   targ_lon_array = (/ -103.0573611, \
                        -96.8189167, \
                       -101.5988405  /);x + 360.0

   targ_lat_array = (/  44.0453333, \
                        44.3045278, \
                        44.0487306  /)

   ;;;; Historical and Future Files

   historical_full_url   = "https://cida.usgs.gov/thredds/dodsC/macav2metdata_daily_historical"
   future_full_url       = "https://cida.usgs.gov/thredds/dodsC/macav2metdata_daily_future"

   ;;;; Generate Ensemble Model Coordinates Coordinates

   ensemble_model = (/ "BNU-ESM_r1i1p1",        \
                       "CCSM4_r6i1p1",          \
                       "CNRM-CM5_r1i1p1",       \
                       "CSIRO-Mk3-6-0_r1i1p1",  \
                       "CanESM2_r1i1p1",        \
                       "GFDL-ESM2G_r1i1p1",     \
                       "GFDL-ESM2M_r1i1p1",     \
                       "HadGEM2-CC365_r1i1p1",  \
                       "HadGEM2-ES365_r1i1p1",  \
                       "IPSL-CM5A-LR_r1i1p1",   \
                       "IPSL-CM5A-MR_r1i1p1",   \
                       "IPSL-CM5B-LR_r1i1p1",   \
                       "MIROC-ESM-CHEM_r1i1p1", \
                       "MIROC-ESM_r1i1p1",      \
                       "MIROC5_r1i1p1",         \
                       "MRI-CGCM3_r1i1p1",      \
                       "NorESM1-M_r1i1p1",      \
                       "bcc-csm1-1-m_r1i1p1",   \
                       "bcc-csm1-1_r1i1p1",     \
                       "inmcm4_r1i1p1"          /)

     ensemble_model!0               = "ensemble_model"
     ensemble_model&ensemble_model  = ensemble_model
     ensemble_model@description     = "Ensemble Model Member"
     ensemble_model@long_name       = ensemble_model@description
   nens = dimsizes(ensemble_model)

   ;;;; Generate CMIP-5 Scenario Coordinates

   RCP_scenario = (/ "RCP 4.5", "RCP 8.5" /)
     RCP_scenario!0            = "RCP_scenario"
     RCP_scenario&RCP_scenario = RCP_scenario
     RCP_scenario@description  = "CMIP-5 Representative Concentration Pathway Scenarios"
     RCP_scenario@long_name    = RCP_scenario@description
   nscen   = dimsizes(RCP_scenario)

   ;;;; Generate Historical CMIP-5 Scenario Inventory Coordinates

   scenario_list   = (/ "Historical", "RCP 4.5", "RCP 8.5" /)
     scenario_list!0             = "scenario_list"
     scenario_list&scenario_list = scenario_list
     scenario_list@description   = "List of Scenarios for Inventory"
     scenario_list@standard_name    = scenario_list@description

   ;;;; Generate Variable Inventory Coordinates

   variable_list   = (/ "Daily Minimum Temperature",      \
                       "Daily Maximum Temperature",       \
                       "Daily Total Precipitation",       \
                       "Daily Mean Eastward Wind Speed",  \
                       "Daily Mean Northward Wind Speed", \
                       "Daily Mean Solar Irradiance",     \
                       "Daily Mean Specific Humidity",    \
                       "Daily Minimum Relative Humidity", \
                       "Daily Maximum Relative Humidity"  /)
     variable_list!0             = "variable_list"
     variable_list&variable_list = variable_list
     variable_list@description   = "List of Variables for Inventory"
     variable_list@standard_name = variable_list@description
   nvars = dimsizes(variable_list)

   ;;;; Create Historical CMIP-5 Scenario Inventory

   available_inventory                  = new((/ nvars, nens, 3 /), integer )
     available_inventory!0              = "variable_list"
     available_inventory&variable_list  = variable_list
     available_inventory!1              = "ensemble_model"
     available_inventory&ensemble_model = ensemble_model
     available_inventory!2              = "scenario_list"
     available_inventory&scenario_list  = scenario_list
     available_inventory@description    = "Inventory of MACA  Scenarios"
     available_inventory@standard_name  = available_inventory@description
     available_inventory@comment        = "1 = available ;  0 = not available"

   available_inventory(:,:,:) = 0

   ;;;; Crack open OPeNDAP files for reading

   fhist = addfile(historical_full_url, "r")
   ffutr = addfile(future_full_url,     "r")

   ;;;; Pull Latitude and Longitude from the Original MACA Files

   longitude_maca = fhist->lon
   latitude_maca  = fhist->lat

   ;;;; Create Historical Arrays

   time_hist = fhist->time
     time_hist!0             = "time_hist"
     time_hist&time_hist     = time_hist
     time_hist@description   = "Time (Historical Period)"
     time_hist@long_name     = time_hist@description
     time_hist@standard_name = "time"
     time_hist@calendar      = "standard"
     time_hist@axis          = "T"
     delete(time_hist@bounds)
     delete(time_hist@_ChunkSizes)
   nth = dimsizes(time_hist)

   tmax_hist = new ((/ nth, nens /), float )
     tmax_hist!0              = "time_hist"
     tmax_hist&time_hist      = time_hist
     tmax_hist!1              = "ensemble_model"
     tmax_hist&ensemble_model = ensemble_model
     tmax_hist@description    = "Maximum Daily Temperature (Historical)"
     tmax_hist@long_name      = tmax_hist@description
     tmax_hist@standard_name  = "air_temperature"
     tmax_hist@units          = "K"
     tmax_hist@cell_methods   = "tmax_hist:maximum"
     tmax_hist@_FillValue     = default_fillvalue("float")
     tmax_hist@coordinates    = "time_hist latitude longitude"

   tmin_hist = tmax_hist
     tmin_hist@description    = "Maximum Daily Temperature (Historical)"
     tmin_hist@long_name      = tmin_hist@description
     tmin_hist@standard_name  = "air_temperature"
     tmin_hist@cell_methods   = "time_hist:maximum"

   prec_hist = tmax_hist
     prec_hist@description    = "Total Daily Precipitation (Historical)"
     prec_hist@long_name      = prec_hist@description
     prec_hist@standard_name  = "precipitation_amount"
     prec_hist@units          = "kg m-2"
     prec_hist@cell_methods   = "time_hist:sum"

   uwnd_hist = tmax_hist
        uwnd_hist@description    = "Average Daily Eastward Wind Speed (Historical)"
        uwnd_hist@long_name      = uwnd_hist@description
        uwnd_hist@standard_name  = "eastward_wind"
        uwnd_hist@units          = "m s-1"
        uwnd_hist@cell_methods   = "time_hist:average"

   vwnd_hist = tmax_hist
        vwnd_hist@description    = "Average Daily Northward Wind Speed (Historical)"
        vwnd_hist@long_name      = vwnd_hist@description
        vwnd_hist@standard_name  = "northward_winds"
        vwnd_hist@units          = "m s-1"
        vwnd_hist@cell_methods   = "time_hist:average"

   flds_hist = tmax_hist
        flds_hist@description    = "Daily Integrated Solar Irradiance (Historical)"
        flds_hist@long_name      = flds_hist@description
        flds_hist@standard_name  = "integral_of_surface_downwelling_shortwave_flux_in_air_wrt_time"
        flds_hist@units          = "J m-2"
        flds_hist@cell_methods   = "time_hist:average"

   qsfc_hist = tmax_hist
        qsfc_hist@description    = "Average Daily Specific Humidity (Historical)"
        qsfc_hist@long_name      = qsfc_hist@description
        qsfc_hist@standard_name  = "specific_humidity"
        qsfc_hist@units          = "kg kg-1"
        qsfc_hist@cell_methods   = "time_hist:average"

   rmax_hist = tmax_hist
       rmax_hist@description    = "Maximum Daily Relative Humidity (Historical)"
       rmax_hist@long_name      = rmax_hist@description
       rmax_hist@standard_name  = "relative_humidity"
       rmax_hist@units          = "percent"
       rmax_hist@cell_methods   = "time_hist:maximum"

   rmin_hist = tmax_hist
       rmin_hist@description    = "Minimum Daily Relative Humidity (Historical)"
       rmin_hist@long_name      = rmin_hist@description
       rmin_hist@standard_name  = "relative_humidity"
       rmin_hist@units          = "percent"
       rmin_hist@cell_methods   = "time_hist:maximum"


   ;;;; Create Future CMIP-5 Scenario Arrays

   time_futr = ffutr->time
     time_futr!0             = "time_futr"
     time_futr&time_futr     = time_futr
     time_futr@description   = "Time (Projected Period)"
     time_futr@long_name     = time_futr@description
     time_futr@standard_name = "time"
     time_futr@calendar      = "standard"
     time_futr@axis          = "T"
     delete(time_futr@bounds)
     delete(time_futr@_ChunkSizes)
   ntf = dimsizes(time_futr)

   tmax_futr = new ((/ ntf, nens, nscen /), float )
     tmax_futr!0              = "time_futr"
     tmax_futr&time_futr      = time_futr
     tmax_futr!1              = "ensemble_model"
     tmax_futr&ensemble_model = ensemble_model
     tmax_futr!2              = "RCP_scenario"
     tmax_futr&RCP_scenario   = RCP_scenario
     tmax_futr@description    = "Maximum Daily Temperature (Projected)"
     tmax_futr@long_name      = tmax_futr@description
     tmax_futr@standard_name  = "air_temperature"
     tmax_futr@units          = "K"
     tmax_futr@cell_methods   = "tmax_futr:maximum"
     tmax_futr@_FillValue     = default_fillvalue("float")
     tmax_futr@coordinates    = "time_futr latitude longitude"

   tmin_futr = tmax_futr
     tmin_futr@description    = "Maximum Daily Temperature (Projected)"
     tmin_futr@long_name      = tmin_futr@description
     tmin_futr@standard_name  = "air_temperature"
     tmin_futr@cell_methods   = "tmax_futr:maximum"

   prec_futr = tmax_futr
     prec_futr@description    = "Total Daily Precipitation (Projected)"
     prec_futr@long_name      = prec_futr@description
     prec_futr@standard_name  = "precipitation_amount"
     prec_futr@units          = "kg m-2"
     prec_futr@cell_methods   = "tmax_futr:sum"

   uwnd_futr = tmax_futr
        uwnd_futr@description    = "Average Daily Eastward Wind Speed (Projected)"
        uwnd_futr@long_name      = uwnd_futr@description
        uwnd_futr@standard_name  = "eastward_wind"
        uwnd_futr@units          = "m s-1"
        uwnd_futr@cell_methods   = "time_hist:average"

   vwnd_futr = tmax_futr
        vwnd_futr@description    = "Average Daily Northward Wind Speed (Projected)"
        vwnd_futr@long_name      = vwnd_futr@description
        vwnd_futr@standard_name  = "northward_winds"
        vwnd_futr@units          = "m s-1"
        vwnd_futr@cell_methods   = "time_hist:average"

   flds_futr = tmax_futr
        flds_futr@description    = "Daily Integrated Solar Irradiance (Projected)"
        flds_futr@long_name      = flds_futr@description
        flds_futr@standard_name  = "integral_of_surface_downwelling_shortwave_flux_in_air_wrt_time"
        flds_futr@units          = "J m-2"
        flds_futr@cell_methods   = "time_hist:average"

   qsfc_futr = tmax_futr
        qsfc_futr@description    = "Average Daily Specific Humidity (Projected)"
        qsfc_futr@long_name      = qsfc_futr@description
        qsfc_futr@standard_name  = "specific_humidity"
        qsfc_futr@units          = "kg kg-1"
        qsfc_futr@cell_methods   = "time_hist:average"

   rmax_futr = tmax_futr
       rmax_futr@description    = "Maximum Daily Relative Humidity (Projected)"
       rmax_futr@long_name      = rmax_futr@description
       rmax_futr@standard_name  = "relative_humidity"
       rmax_futr@units          = "percent"
       rmax_futr@cell_methods   = "time_hist:maximum"

   rmin_futr = tmax_futr
       rmin_futr@description    = "Minimum Daily Relative Humidity (Projected)"
       rmin_futr@long_name      = rmin_futr@description
       rmin_futr@standard_name  = "relative_humidity"
       rmin_futr@units          = "percent"
       rmin_futr@cell_methods   = "time_hist:maximum"

   ;;; Begin Looping through Locations and Sites

   do loc = 0, dimsizes(location_name_array)-1

     print("=================================================")

     netcdf_outfile = "./"+location_abbr_array(loc)+"_MACA.nc"

     ;;;; Load Station-Specific Metadata

     latitude_station = (/ targ_lat_array(loc) /)
        latitude_station!0             = "ncl_scalar"
        latitude_station@description   = "Latitude of Station"
        latitude_station@long_name     = latitude_station@description
        latitude_station@standard_name = "latitude"
        latitude_station@units         = "degrees_north"

     longitude_station = (/ targ_lon_array(loc) /)
        longitude_station!0             = "ncl_scalar"
        longitude_station@description   = "Longitude of Station"
        longitude_station@long_name     = longitude_station@description
        longitude_station@standard_name = "longitude"
        longitude_station@units         = "degrees_east"

     station_name = (/ location_name_array(loc) /)
        station_name!0           = "ncl_scalar"
        station_name@description = "Station Name"
        station_name@long_name   = station_name@description

     station_icao = (/ location_abbr_array(loc) /)
        station_icao!0           = "ncl_scalar"
        station_icao@description = "Station ICAO Designator"
        station_icao@long_name   = station_icao@description

     latitude = (/ latitude_maca({latitude_station}) /)
        latitude!0             = "ncl_scalar"
        latitude@description   = "Latitude of Grid Point"
        latitude@long_name     = latitude@description
        latitude@standard_name = "latitude"
        latitude@units         = "degrees_north"
        latitude@axis          = "Y"

     longitude = (/ longitude_maca({longitude_station}) /)
        longitude!0             = "ncl_scalar"
        longitude@description   = "Longitude of Grid Point"
        longitude@long_name     = longitude@description
        longitude@standard_name = "longitude"
        longitude@units         = "degrees_west"
        longitude@axis          = "X"

     great_circle_distance_error_in_km = gc_latlon(latitude_station,longitude_station,latitude,longitude,1,4)
        great_circle_distance_error_in_km!0           = "ncl_scalar"
        great_circle_distance_error_in_km@description = "Separation Distance Between ICAO station and Grid Cell Center"
        great_circle_distance_error_in_km@long_name   = great_circle_distance_error_in_km@description
        great_circle_distance_error_in_km@units       = "km"
        great_circle_distance_error_in_km@comment     = "created using gc_latlon() function"

     tmax_hist = tmax_hist@_FillValue
     tmin_hist = tmin_hist@_FillValue
     prec_hist = prec_hist@_FillValue
     uwnd_hist = uwnd_hist@_FillValue
     vwnd_hist = prec_hist@_FillValue
     flds_hist = flds_hist@_FillValue
     qsfc_hist = qsfc_hist@_FillValue
     rmax_hist = rmax_hist@_FillValue
     rmin_hist = rmin_hist@_FillValue

     tmax_futr = tmax_futr@_FillValue
     tmin_futr = tmin_futr@_FillValue
     prec_futr = prec_futr@_FillValue
     uwnd_futr = uwnd_futr@_FillValue
     vwnd_futr = prec_futr@_FillValue
     flds_futr = flds_futr@_FillValue
     qsfc_futr = qsfc_futr@_FillValue
     rmax_futr = rmax_futr@_FillValue
     rmin_futr = rmin_futr@_FillValue

     ;;;; Loop through Ensemble Model Members

     do ens = 0, nens-1

      v = -1

      ;;;; Maximum Daily Temperature

      v = v + 1

      vname = "tasmax_" + ensemble_model(ens) + "_historical"
        if (isfilevar(fhist,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme            = fhist->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           if (deleteme@units .eq. "C") then
              tmax_hist(:,ens) = (/ tofloat(deleteme) * scale + 273.15 /)
           else
              tmax_hist(:,ens) = (/ tofloat(deleteme) * scale  /)
           end if
           print("    - range: " + min(tmax_hist(:,ens)) + " : " \
                                 + max(tmax_hist(:,ens)))
           delete(deleteme)
           available_inventory(0,ens,0) = 1
        end if

      vname = "tasmax_" + ensemble_model(ens) + "_rcp45"
        if (isfilevar(ffutr,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme            = ffutr->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           if (deleteme@units .eq. "C") then
              tmax_futr(:,ens,0) = (/ tofloat(deleteme) * scale + 273.15 /)
           else
              tmax_futr(:,ens,0) = (/ tofloat(deleteme) * scale  /)
           end if
           print("    - range: " + min(tmax_futr(:,ens,0)) + " : " \
                                 + max(tmax_futr(:,ens,0)))
           delete(deleteme)
           available_inventory(0,ens,1) = 1
        end if

      vname = "tasmax_" + ensemble_model(ens) + "_rcp85"
        if (isfilevar(ffutr,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme            = ffutr->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           if (deleteme@units .eq. "C") then
              tmax_futr(:,ens,1) = (/ tofloat(deleteme) * scale + 273.15 /)
           else
              tmax_futr(:,ens,1) = (/ tofloat(deleteme) * scale  /)
           end if
           print("    - range: " + min(tmax_futr(:,ens,1)) + " : " \
                                 + max(tmax_futr(:,ens,1)))
           delete(deleteme)
           available_inventory(0,ens,2) = 1
        end if

        print("- - - - - - - - - - - - - - - - - - - - - - - - -")


      ;;;; Minimum Daily Temperature

      v = v + 1

      vname = "tasmin_" + ensemble_model(ens) + "_historical"
        if (isfilevar(fhist,vname)) then
           deleteme         = fhist->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           if (deleteme@units .eq. "C") then
              tmin_hist(:,ens) = (/ tofloat(deleteme) * scale + 273.15 /)
           else
              tmin_hist(:,ens) = (/ tofloat(deleteme) * scale  /)
           end if
           print("    - range: " + min(tmin_hist(:,ens)) + " : " \
                                 + max(tmin_hist(:,ens)))
           delete(deleteme)
           available_inventory(1,ens,0) = 1
      end if

      vname = "tasmin_" + ensemble_model(ens) + "_rcp45"
        if (isfilevar(ffutr,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme           = ffutr->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           if (deleteme@units .eq. "C") then
              tmin_futr(:,ens,0) = (/ tofloat(deleteme) * scale + 273.15 /)
           else
              tmin_futr(:,ens,0) = (/ tofloat(deleteme) * scale  /)
           end if
           print("    - range: " + min(tmin_futr(:,ens,0)) + " : " \
                                 + max(tmin_futr(:,ens,0)))
           delete(deleteme)
           available_inventory(1,ens,1) = 1
        end if

      vname = "tasmin_" + ensemble_model(ens) + "_rcp85"
        if (isfilevar(ffutr,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme           = ffutr->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           if (deleteme@units .eq. "C") then
              tmin_futr(:,ens,1) = (/ tofloat(deleteme) * scale + 273.15 /)
           else
              tmin_futr(:,ens,1) = (/ tofloat(deleteme) * scale  /)
           end if
           print("    - range: " + min(tmin_futr(:,ens,1)) + " : " \
                                 + max(tmin_futr(:,ens,1)))
           delete(deleteme)
           available_inventory(1,ens,2) = 1
        end if

        print("- - - - - - - - - - - - - - - - - - - - - - - - -")

      ;;;; Daily Total Precipitation

      v = v + 1

      vname = "pr_" + ensemble_model(ens) + "_historical"
        if (isfilevar(fhist,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme         = fhist->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           if (deleteme@units .eq. "mm") then
              prec_hist(:,ens) = (/ tofloat(deleteme) * scale /)
           else
              prec_hist(:,ens) = (/ tofloat(deleteme) * scale * 86400.  /)
           end if
           print("    - range: " + min(prec_hist(:,ens)) + " : " \
                                 + max(prec_hist(:,ens)))
        delete(deleteme)
        available_inventory(2,ens,0) = 1
      end if

      vname = "pr_" + ensemble_model(ens) + "_rcp45"
        if (isfilevar(ffutr,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme           = ffutr->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           if (deleteme@units .eq. "mm") then
              prec_futr(:,ens,0) = (/ tofloat(deleteme) * scale /)
           else
              prec_futr(:,ens,0) = (/ tofloat(deleteme) * scale * 86400.  /)
           end if
           print("    - range: " + min(prec_futr(:,ens,0)) + " : " \
                                 + max(prec_futr(:,ens,0)))
           delete(deleteme)
           available_inventory(2,ens,1) = 1
        end if

      vname = "pr_" + ensemble_model(ens) + "_rcp85"
        if (isfilevar(ffutr,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme           = ffutr->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           if (deleteme@units .eq. "mm") then
              prec_futr(:,ens,1) = (/ tofloat(deleteme) * scale /)
           else
              prec_futr(:,ens,1) = (/ tofloat(deleteme) * scale * 86400.  /)
           end if
           print("    - range: " + min(prec_futr(:,ens,1)) + " : " \
                                 + max(prec_futr(:,ens,1)))
           delete(deleteme)
           available_inventory(2,ens,2) = 1
        end if

      print("-------------------------------------------------")


      ;;;; Daily Average Eastward Wind Speed

      v = v + 1

      vname = "uas_" + ensemble_model(ens) + "_historical"
        if (isfilevar(fhist,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme         = fhist->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           if (deleteme@units .eq. "mm") then
              uwnd_hist(:,ens) = (/ tofloat(deleteme) * scale /)
           else
              uwnd_hist(:,ens) = (/ tofloat(deleteme) * scale  /)
           end if
           print("    - range: " + min(uwnd_hist(:,ens)) + " : " \
                                 + max(uwnd_hist(:,ens)))
        delete(deleteme)
        available_inventory(v,ens,0) = 1
      end if

      vname = "uas_" + ensemble_model(ens) + "_rcp45"
        if (isfilevar(ffutr,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme           = ffutr->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           if (deleteme@units .eq. "mm") then
              uwnd_futr(:,ens,0) = (/ tofloat(deleteme) * scale /)
           else
              uwnd_futr(:,ens,0) = (/ tofloat(deleteme) * scale  /)
           end if
           print("    - range: " + min(uwnd_futr(:,ens,0)) + " : " \
                                 + max(uwnd_futr(:,ens,0)))
           delete(deleteme)
           available_inventory(v,ens,1) = 1
        end if

      vname = "uas_" + ensemble_model(ens) + "_rcp85"
        if (isfilevar(ffutr,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme           = ffutr->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           if (deleteme@units .eq. "mm") then
              uwnd_futr(:,ens,1) = (/ tofloat(deleteme) * scale /)
           else
              uwnd_futr(:,ens,1) = (/ tofloat(deleteme) * scale  /)
           end if
           print("    - range: " + min(uwnd_futr(:,ens,1)) + " : " \
                                 + max(uwnd_futr(:,ens,1)))
           delete(deleteme)
           available_inventory(v,ens,2) = 1
        end if

      print("-------------------------------------------------")

      ;;;; Daily Average Nortward Wind Speed

      v = v + 1

      vname = "vas_" + ensemble_model(ens) + "_historical"
       if (isfilevar(fhist,vname)) then
          print("Processing " + station_icao + " " + vname)
          deleteme         = fhist->$vname$( :, {latitude}, {longitude})
          if (isatt(deleteme, "scale_factor")) then
             scale            = deleteme@scale_factor
          else
             scale            = 1.0
          end if
          if (deleteme@units .eq. "mm") then
             vwnd_hist(:,ens) = (/ tofloat(deleteme) * scale /)
          else
             vwnd_hist(:,ens) = (/ tofloat(deleteme) * scale /)
          end if
          print("    - range: " + min(vwnd_hist(:,ens)) + " : " \
                                + max(vwnd_hist(:,ens)))
       delete(deleteme)
       available_inventory(v,ens,0) = 1
      end if

      vname = "vas_" + ensemble_model(ens) + "_rcp45"
       if (isfilevar(ffutr,vname)) then
          print("Processing " + station_icao + " " + vname)
          deleteme           = ffutr->$vname$( :, {latitude}, {longitude})
          if (isatt(deleteme, "scale_factor")) then
             scale            = deleteme@scale_factor
          else
             scale            = 1.0
          end if
          if (deleteme@units .eq. "mm") then
             uwnd_futr(:,ens,0) = (/ tofloat(deleteme) * scale /)
          else
             vwnd_futr(:,ens,0) = (/ tofloat(deleteme) * scale  /)
          end if
          print("    - range: " + min(vwnd_futr(:,ens,0)) + " : " \
                                + max(vwnd_futr(:,ens,0)))
          delete(deleteme)
          available_inventory(v,ens,1) = 1
       end if

      vname = "vas_" + ensemble_model(ens) + "_rcp85"
       if (isfilevar(ffutr,vname)) then
          print("Processing " + station_icao + " " + vname)
          deleteme           = ffutr->$vname$( :, {latitude}, {longitude})
          if (isatt(deleteme, "scale_factor")) then
             scale            = deleteme@scale_factor
          else
             scale            = 1.0
          end if
          if (deleteme@units .eq. "mm") then
             vwnd_futr(:,ens,1) = (/ tofloat(deleteme) * scale /)
          else
             vwnd_futr(:,ens,1) = (/ tofloat(deleteme) * scale  /)
          end if
          print("    - range: " + min(vwnd_futr(:,ens,1)) + " : " \
                                + max(vwnd_futr(:,ens,1)))
          delete(deleteme)
          available_inventory(v,ens,2) = 1
       end if

      print("-------------------------------------------------")


      ;;;; Daily Average Nortward Wind Speed

      v = v + 1

      vname = "rsds_" + ensemble_model(ens) + "_historical"
       if (isfilevar(fhist,vname)) then
          print("Processing " + station_icao + " " + vname)
          deleteme         = fhist->$vname$( :, {latitude}, {longitude})
          if (isatt(deleteme, "scale_factor")) then
             scale            = deleteme@scale_factor
          else
             scale            = 1.0
          end if
          if (deleteme@units .eq. "mm") then
             flds_hist(:,ens) = (/ tofloat(deleteme) * scale * 86400.0 /)
          else
             flds_hist(:,ens) = (/ tofloat(deleteme) * scale * 86400.0 /)
          end if
          print("    - range: " + min(flds_hist(:,ens)) + " : " \
                                + max(flds_hist(:,ens)))
       delete(deleteme)
       available_inventory(v,ens,0) = 1
      end if

      vname = "rsds_" + ensemble_model(ens) + "_rcp45"
       if (isfilevar(ffutr,vname)) then
          print("Processing " + station_icao + " " + vname)
          deleteme           = ffutr->$vname$( :, {latitude}, {longitude})
          if (isatt(deleteme, "scale_factor")) then
             scale            = deleteme@scale_factor
          else
             scale            = 1.0
          end if
          if (deleteme@units .eq. "mm") then
             flds_futr(:,ens,0) = (/ tofloat(deleteme) * scale * 86400.0 /)
          else
             flds_futr(:,ens,0) = (/ tofloat(deleteme) * scale * 86400.0 /)
          end if
          print("    - range: " + min(flds_futr(:,ens,0)) + " : " \
                                + max(flds_futr(:,ens,0)))
          delete(deleteme)
          available_inventory(v,ens,1) = 1
       end if

      vname = "rsds_" + ensemble_model(ens) + "_rcp85"
       if (isfilevar(ffutr,vname)) then
          print("Processing " + station_icao + " " + vname)
          deleteme           = ffutr->$vname$( :, {latitude}, {longitude})
          if (isatt(deleteme, "scale_factor")) then
             scale            = deleteme@scale_factor
          else
             scale            = 1.0
          end if
          if (deleteme@units .eq. "mm") then
             flds_futr(:,ens,1) = (/ tofloat(deleteme) * scale * 86400.0 /)
          else
             flds_futr(:,ens,1) = (/ tofloat(deleteme) * scale * 86400.0 /)
          end if
          print("    - range: " + min(flds_futr(:,ens,1)) + " : " \
                                + max(flds_futr(:,ens,1)))
          delete(deleteme)
          available_inventory(v,ens,2) = 1
       end if

      print("-------------------------------------------------")

      ;;;; Daily Average Specific Humidity

      v = v + 1

      vname = "huss_" + ensemble_model(ens) + "_historical"
       if (isfilevar(fhist,vname)) then
          print("Processing " + station_icao + " " + vname)
          deleteme         = fhist->$vname$( :, {latitude}, {longitude})
          if (isatt(deleteme, "scale_factor")) then
             scale            = deleteme@scale_factor
          else
             scale            = 1.0
          end if
          if (deleteme@units .eq. "mm") then
             qsfc_hist(:,ens) = (/ tofloat(deleteme) * scale /)
          else
             qsfc_hist(:,ens) = (/ tofloat(deleteme) * scale /)
          end if
          print("    - range: " + min(qsfc_hist(:,ens)) + " : " \
                                + max(qsfc_hist(:,ens)))
       delete(deleteme)
       available_inventory(v,ens,0) = 1
      end if

      vname = "huss_" + ensemble_model(ens) + "_rcp45"
       if (isfilevar(ffutr,vname)) then
          print("Processing " + station_icao + " " + vname)
          deleteme           = ffutr->$vname$( :, {latitude}, {longitude})
          if (isatt(deleteme, "scale_factor")) then
             scale            = deleteme@scale_factor
          else
             scale            = 1.0
          end if
          if (deleteme@units .eq. "mm") then
             qsfc_futr(:,ens,0) = (/ tofloat(deleteme) * scale /)
          else
             qsfc_futr(:,ens,0) = (/ tofloat(deleteme) * scale /)
          end if
          print("    - range: " + min(qsfc_futr(:,ens,0)) + " : " \
                                + max(qsfc_futr(:,ens,0)))
          delete(deleteme)
          available_inventory(v,ens,1) = 1
       end if

      vname = "huss_" + ensemble_model(ens) + "_rcp85"
       if (isfilevar(ffutr,vname)) then
          print("Processing " + station_icao + " " + vname)
          deleteme           = ffutr->$vname$( :, {latitude}, {longitude})
          if (isatt(deleteme, "scale_factor")) then
             scale            = deleteme@scale_factor
          else
             scale            = 1.0
          end if
          if (deleteme@units .eq. "mm") then
             qsfc_futr(:,ens,1) = (/ tofloat(deleteme) * scale /)
          else
             qsfc_futr(:,ens,1) = (/ tofloat(deleteme) * scale /)
          end if
          print("    - range: " + min(qsfc_futr(:,ens,1)) + " : " \
                                + max(qsfc_futr(:,ens,1)))
          delete(deleteme)
          available_inventory(v,ens,2) = 1
       end if

      print("-------------------------------------------------")


      ;;;; Maximum Daily Relative Humidity

      v = v + 1

      vname = "rhsmax_" + ensemble_model(ens) + "_historical"
       if (isfilevar(fhist,vname)) then
          print("Processing " + station_icao + " " + vname)
          deleteme            = fhist->$vname$( :, {latitude}, {longitude})
          if (isatt(deleteme, "scale_factor")) then
             scale            = deleteme@scale_factor
          else
             scale            = 1.0
          end if
          if (deleteme@units .eq. "C") then
             res_xy_log_scalemax_hist(:,ens) = (/ tofloat(deleteme) * scale /)
          else
             rmax_hist(:,ens) = (/ tofloat(deleteme) * scale  /)
          end if
          print("    - range: " + min(rmax_hist(:,ens)) + " : " \
                                + max(rmax_hist(:,ens)))
          delete(deleteme)
          available_inventory(0,ens,0) = 1
       end if

      vname = "rhsmax_" + ensemble_model(ens) + "_rcp45"
       if (isfilevar(ffutr,vname)) then
          print("Processing " + station_icao + " " + vname)
          deleteme            = ffutr->$vname$( :, {latitude}, {longitude})
          if (isatt(deleteme, "scale_factor")) then
             scale            = deleteme@scale_factor
          else
             scale            = 1.0
          end if
          if (deleteme@units .eq. "C") then
             rmax_futr(:,ens,0) = (/ tofloat(deleteme) * scale /)
          else
             rmax_futr(:,ens,0) = (/ tofloat(deleteme) * scale  /)
          end if
          print("    - range: " + min(rmax_futr(:,ens,0)) + " : " \
                                + max(rmax_futr(:,ens,0)))
          delete(deleteme)
          available_inventory(0,ens,1) = 1
       end if

      vname = "rhsmax_" + ensemble_model(ens) + "_rcp85"
       if (isfilevar(ffutr,vname)) then
          print("Processing " + station_icao + " " + vname)
          deleteme            = ffutr->$vname$( :, {latitude}, {longitude})
          if (isatt(deleteme, "scale_factor")) then
             scale            = deleteme@scale_factor
          else
             scale            = 1.0
          end if
          if (deleteme@units .eq. "C") then
             rmax_futr(:,ens,1) = (/ tofloat(deleteme) * scale  /)
          else
             rmax_futr(:,ens,1) = (/ tofloat(deleteme) * scale  /)
          end if
          print("    - range: " + min(rmax_futr(:,ens,1)) + " : " \
                                + max(rmax_futr(:,ens,1)))
          delete(deleteme)
          available_inventory(0,ens,2) = 1
       end if

       print("- - - - - - - - - - - - - - - - - - - - - - - - -")


      ;;;; Minimum Daily Relative Humidity

      v = v + 1

      vname = "rhsmin_" + ensemble_model(ens) + "_historical"
        if (isfilevar(fhist,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme            = fhist->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           rmin_hist(:,ens) = (/ tofloat(deleteme) * scale /)
           print("    - range: " + min(rmin_hist(:,ens)) + " : " \
                                 + max(rmin_hist(:,ens)))
           delete(deleteme)
           available_inventory(0,ens,0) = 1
        end if

      vname = "rhsmin_" + ensemble_model(ens) + "_rcp45"
        if (isfilevar(ffutr,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme            = ffutr->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           rmin_futr(:,ens,0) = (/ tofloat(deleteme) * scale /)
           print("    - range: " + min(rmin_futr(:,ens,0)) + " : " \
                                 + max(rmin_futr(:,ens,0)))
           delete(deleteme)
           available_inventory(0,ens,1) = 1
        end if

      vname = "rhsmin_" + ensemble_model(ens) + "_rcp85"
        if (isfilevar(ffutr,vname)) then
           print("Processing " + station_icao + " " + vname)
           deleteme            = ffutr->$vname$( :, {latitude}, {longitude})
           if (isatt(deleteme, "scale_factor")) then
              scale            = deleteme@scale_factor
           else
              scale            = 1.0
           end if
           rmin_futr(:,ens,1) = (/ tofloat(deleteme) * scale  /)
           print("    - range: " + min(rmin_futr(:,ens,1)) + " : " \
                                 + max(rmin_futr(:,ens,1)))
           delete(deleteme)
           available_inventory(0,ens,2) = 1
        end if

        print("- - - - - - - - - - - - - - - - - - - - - - - - -")


     end do

     print("=================================================")

     ;;;; Output to File

     system("rm -frv "+netcdf_outfile)

     fout = addfile(netcdf_outfile, "c")

        ;;;; Metadata

        fout@title               = "CIDA THREDDS Holdings/Multivariate Adaptive Constructed Analogs (MACA) CMIP5 Statistically Downscaled Data for Coterminous USA/Daily Historical MACAv2METDATA"
        fout@creator_name        = "Original: Dohn Abatzoglou (U Idaho); " + tochar(10) + \
                                   "Modified: Bill Capehart SD School of Mines"
        fout@creator_email       = "Original: jabatzoglou@uidaho.edu; " + tochar(10) + \
                                   "Modified: William.Capehart@sdsmt.edu"
        fout@institution         = "Original: Applied Climate Science Lab, University of Idaho; " + tochar(10) + \
                                   "Modified: SD School of Mines and Technology"
        fout@Conventions         = "CF-1.4"
        fout@project             = "Comparative Analysis of Downscaled Climate Simulations, Providing Guidance to End Users"
        fout@cdm_data_type       = "Station"
        fout@summary             = "This archive contains daily downscaled meteorological and hydrological projections " + \
                                   "for the Conterminous United States at 1/24-deg resolution utilizing the Multivariate " + \
                                   "Adaptive Constructed Analogs (MACA, Abatzoglou, 2012) statistical downscaling method " + \
                                   "with the METDATA (Abatzoglou,2013) training dataset. The downscaled meteorological " + \
                                   "variables are maximum/minimum temperature(tasmax/tasmin), maximum/minimum relative  " + \
                                   "humidity (rhsmax/rhsmin)precipitation amount(pr), downward shortwave solar radiation(rsds), " + \
                                   "eastward wind(uas), northward wind(vas), and specific humidity(huss). The downscaling " + \
                                   "is based on the 365-day model outputs from different global climate models (GCMs) from " + \
                                   "Phase 5 of the Coupled Model Inter-comparison Project (CMIP3) utlizing the historical " + \
                                   "(1950-2005) and future RCP4.5/8.5(2006-2099) scenarios. Leap days have been added to the " + \
                                   "dataset from the average values between Feb 28 and Mar 1 in order to aid modelers " + \
                                   "See: http://maca.northwestknowledge.net/ for more information. " + \
                                   "Acknowledgement: The dataset MACAv2-METDATA was produced with funding from the Regional " + \
                                   "Approaches to Climate Change (REACCH) project and the SouthEast Climate Science " + \
                                   "Center (SECSC). We acknowledge the World Climate Research Programme's Working Group " + \
                                   "on Coupled Modeling, which is responsible for CMIP, and we thank the climate modeling " + \
                                   "groups for producing and making available their model output. For CMIP, the U.S. Department " + \
                                   "of Energy's Program for Climate Model Diagnosis and Intercomparison provides coordinating " + \
                                   "support and led development of software infrastructure in partnership with the Global " + \
                                   "Organization for Earth System Science Portals."

        fout@acknowledgment      = "Abatzoglou J. T.  Development of gridded surface meteorological data for ecological " + \
                                   "applications and modelling.  International Journal of Climatology. (2011), doi: 10.1002/joc.3413. " + tochar(10) + \
                                   "Abatzoglou J.T. and Brown T.J. A comparison of statistical downscaling methods suited for " + \
                                   "wildfire applications. International Journal of Climatology (2012),doi: 10.1002/joc.2312.  " + tochar(10) + \
                                   "Hegewisch,K.C., Abatzoglou J.T., An improved Multivariate Adaptive Constructed Analogs (MACA)"  + \
                                   "statistical Downscaling Method. In preparation.  " + tochar(10) + \
                                   "Also see: http://maca.northwestknowledge.net/MACAreferences.php"
        fout@comment             = "Original Prioduct Extracted to a Single Station Point, Original Prioduct Calibrated to full units, Forecast Model Ensembles Colated into a single variable and by CMIP-5 RCP Scenario for future run data"
        fout@history             = "Dataset was created by John Abatzoglou and deflated and aggregated for publication by the USGS by dblodgett@usgs.gov in May 2016.  " + tochar(10) + \
                                   "Dataset was extracted for a single point and converted to common SI units by William.Capehart@sdsmt.edu in October 2017"
         fout@URL                = "http://climate.nkn.uidaho.edu/MACA/"


        fout@time_coverage_start = "1950-01-01T00:00"
        fout@time_coverage_end   = "2100-12-31T00:00"
        fout@station_name        = station_name
        fout@station_icao        = station_icao
        fout@latitude_station    = latitude_station
        fout@longitude_station   = longitude_station + 360.
        fout@geospatial_lat_min  = latitude
        fout@geospatial_lat_max  = latitude
        fout@geospatial_lon_min  = longitude + 360.
        fout@geospatial_lon_max  = longitude + 360.
        fout@keywords            = "precipitation, temperature, solar radiation, relative humidity, wund speed, specific humidity"
        fout@license             = "Freely available"

        ;;;; Coordinates

        fout->latitude                          = latitude
        fout->longitude                         = longitude + 360.
        fout->station_name                      = station_name
        fout->station_icao                      = station_icao
        fout->latitude_station                  = latitude_station
        fout->longitude_station                 = longitude_station + 360.
        fout->great_circle_distance_error_in_km = great_circle_distance_error_in_km
        fout->time_hist                         = time_hist
        fout->time_futr                         = time_futr
        fout->ensemble_model                    = ensemble_model
        fout->RCP_scenario                      = RCP_scenario
        fout->scenario_list                     = scenario_list
        fout->available_inventory               = available_inventory

        ;;;; Historical Data

        fout->tmax_hist = tmax_hist
        fout->tmin_hist = tmin_hist
        fout->prec_hist = prec_hist
        fout->uwnd_hist = uwnd_hist
        fout->vwnd_hist = prec_hist
        fout->flds_hist = flds_hist
        fout->qsfc_hist = qsfc_hist
        fout->rmax_hist = rmax_hist
        fout->rmin_hist = rmin_hist


        ;;;; Projected RCP 4.5 & RCP 8.5 Data

        fout->tmax_futr = tmax_futr
        fout->tmin_futr = tmin_futr
        fout->prec_futr = prec_futr
        fout->uwnd_futr = uwnd_futr
        fout->vwnd_futr = vwnd_futr
        fout->flds_futr = flds_futr
        fout->qsfc_futr = qsfc_futr
        fout->rmax_futr = rmax_futr
        fout->rmin_futr = rmin_futr

        delete(fout)

         tmax_hist = tmax_hist@_FillValue
         tmin_hist = tmin_hist@_FillValue
         prec_hist = prec_hist@_FillValue
         uwnd_hist = uwnd_hist@_FillValue
         vwnd_hist = prec_hist@_FillValue
         flds_hist = flds_hist@_FillValue
         qsfc_hist = qsfc_hist@_FillValue
         rmax_hist = rmax_hist@_FillValue
         rmin_hist = rmin_hist@_FillValue

         tmax_futr = tmax_futr@_FillValue
         tmin_futr = tmin_futr@_FillValue
         prec_futr = prec_futr@_FillValue
         uwnd_futr = uwnd_futr@_FillValue
         vwnd_futr = prec_futr@_FillValue
         flds_futr = flds_futr@_FillValue
         qsfc_futr = qsfc_futr@_FillValue
         rmax_futr = rmax_futr@_FillValue
         rmin_futr = rmin_futr@_FillValue

   end do




end
