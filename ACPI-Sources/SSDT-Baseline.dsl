// Derived from supplied MaLd0n Mob 1.2 SSDT. Original author credit retained.
// BASELINE-DERIVED TEST CANDIDATE: Dell firmware namespace not supplied.
DefinitionBlock ("", "SSDT", 2, "DELL", "V2BASE", 0x00000002)
{
    External (_PR_.CPU0, DeviceObj)
    External (_PR_.PR00, DeviceObj)
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.SBUS, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB, DeviceObj)
    External (_SB_.PR00, DeviceObj)
    External (GPEN, UnknownObj)
    External (GPHD, UnknownObj)

    Method (XOSI, 1, NotSerialized)
    {
        Local0 = Package (0x0D)
            {
                "Windows 2000", 
                "Windows 2001", 
                "Windows 2001 SP1", 
                "Windows 2001.1", 
                "Windows 2001 SP2", 
                "Windows 2001.1 SP1", 
                "Windows 2006", 
                "Windows 2006 SP1", 
                "Windows 2006.1", 
                "Windows 2009", 
                "Windows 2012", 
                "Windows 2013", 
                "Windows 2015"
            }
        If (_OSI ("Darwin"))
        {
            Return ((Match (Local0, MEQ, Arg0, MTR, Zero, Zero) != Ones))
        }
        Else
        {
            Return (_OSI (Arg0))
        }
    }

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            If (CondRefOf (GPHD)) { GPHD = Zero }
            If (CondRefOf (GPEN)) { GPEN = One }
        }
    }

    Scope (\_SB)
    {
        Device (EC)
        {
            Name (_HID, "MALD0001")  // _HID: Hardware ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }

    Scope (\_SB)
    {
        Device (PNLF)
        {
            Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
            Name (_CID, "backlight")  // _CID: Compatible ID
            Name (_UID, 0x10)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0B)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }

    Scope (\_SB)
    {
        Device (USBX)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If (!Arg2)
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                Return (Package (0x08)
                {
                    "kUSBSleepPowerSupply", 
                    0x13EC, 
                    "kUSBSleepPortCurrentLimit", 
                    0x0834, 
                    "kUSBWakePowerSupply", 
                    0x13EC, 
                    "kUSBWakePortCurrentLimit", 
                    0x0834
                })
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }

    If (CondRefOf (\_PR.CPU0))
    {
        If ((ObjectType (\_PR.CPU0) == 0x0C))
        {
            Scope (\_PR.CPU0)
            {
                If (_OSI ("Darwin"))
                {
                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Return (PMPM (Arg0, Arg1, Arg2, Arg3))
                    }
                }
            }
        }
    }

    If (CondRefOf (\_SB.PR00))
    {
        If ((ObjectType (\_SB.PR00) == 0x0C))
        {
            Scope (\_SB.PR00)
            {
                If (_OSI ("Darwin"))
                {
                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Return (PMPM (Arg0, Arg1, Arg2, Arg3))
                    }
                }
            }
        }
    }

    If (CondRefOf (\_PR.PR00))
    {
        If ((ObjectType (\_PR.PR00) == 0x0C))
        {
            Scope (\_PR.PR00)
            {
                If (_OSI ("Darwin"))
                {
                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Return (PMPM (Arg0, Arg1, Arg2, Arg3))
                    }
                }
            }
        }
    }





    Method (PMPM, 4, NotSerialized)
    {
        If ((!Arg2 || !_OSI ("Darwin")))
        {
            Return (Buffer (One)
            {
                 0x03                                             // .
            })
        }

        Return (Package (0x02)
        {
            "plugin-type", 
            One
        })
    }
}

