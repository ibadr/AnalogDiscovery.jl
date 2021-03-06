using AnalogDiscovery

function go()
  cDev = enumDevices()
  @show ("Available",cDev)
  myDev = Int32(0)
  if cDev > 0
    if enumDeviceIsOpened(myDev)
      error("Error opening device, already in use.")
    end
    hdwf = deviceOpen(myDev)
  else
    error("No devices available.")
  end

  pfsInput = Ref{Cuint}()
  # Similar to DigitalIO example in Python
  for i in 1:10
    # Enable output/mask on 8 LSB IO pins, from DIO 0 to 7
    digitalIOOutputEnableSet(hdwf, UInt32(0x00FF))
    # Set value on enabled IO pins
    digitalIOOutputSet(hdwf, UInt32(0x12))
    # Fetch digital IO information from the device
    digitalIOStatus(hdwf)
    # Read state of all pins, regardless of output enable
    val = digitalIOInputStatus!(pfsInput,hdwf)
    show(val)
  end

  deviceClose(hdwf)
end

go()
