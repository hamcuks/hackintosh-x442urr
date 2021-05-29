DefinitionBlock ("", "SSDT", 2, "HAMCUK", "Hack", 0)
{
    
    Scope (\)
    {
        // method osdw to check the booted kernel
        Method (OSDW)
        {
            If (_OSI ("Darwin"))
            {
                Return (One)
            } Else
            {
                Return (Zero)
            }
        }
    }
    
    // import Processor obj to inject plugin type
    External (\_PR.PR00, ProcessorObj)
    Scope (\_PR.PR00)
    {
        Method (_DSM, 4)
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer () { 0x03 })
            }
            
            If (OSDW)
            {
                Return (Package ()
                {
                    "plugin-type",
                    One
                })
            }
        }
    }
    
    Scope (\_SB)
    {
        
        // USBX Patch
        Device (USBX)
        {
            Name (_ADR, Zero)
            Method (_STA)
            {
                If (OSDW)
                {
                    Return (One)
                } Else
                {
                    Return (Zero)
                }
            }
            Method (_DSM, 4)
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer () { 0x03 })
                }
                
                Return (Package ()
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
        }
        
        // PNLF for Kabylake
        Device (PNLF)
        {
            Name (_ADR, Zero)
            Name (_HID, EisaId ("APP0002"))
            Name (_CID, "backlight")
            Name (_UID, 0x10)
            Method (_STA)
            {
                If (OSDW)
                {
                    Return (0x0B)
                } Else
                {
                    Return (Zero)
                }
            }
        }
    }
    
    // MAIN PATCH GOES HERE
    
    // Import PCI0 Object
    External (\_SB.PCI0, DeviceObj)
    Scope (\_SB.PCI0)
    {
        // import LPCB obj and creating fake ec
        External (LPCB, DeviceObj)
        Device (LPCB.EC)
        {
            Name (_HID, "HAMC0000")
            Method (_STA)
            {
                If (OSDW)
                {
                    Return (One)
                } Else
                {
                    Return (Zero)
                }
            }
        }
        
        // import EC0 obj
        External (LPCB.EC0, DeviceObj)
        Scope (LPCB.EC0)
        {
            
            // import ATKP and ATKD.IANE
            External (\_SB.ATKP, UnknownObj)
            External (\_SB.ATKD.IANE, MethodObj)
            
            // EC Query Patch begin
            
            // Fn + F1
            Method (_Q0A)
            {
                If (OSDW)
                {
                    If (\_SB.ATKP)
                    {
                        \_SB.ATKD.IANE (0x5E)
                    }                
                } Else
                {
                    // import original Ec Query
                    External (^XQ0A, MethodObj)
                    ^XQ0A ()
                }
            }
            
            // Fn + F2
            Method (_Q0B)
            {
                If (OSDW)
                {
                    If (\_SB.ATKP)
                    {
                        \_SB.ATKD.IANE (0x7D)
                    }
                } Else
                {
                    // import original Ec Query
                    External (^XQ0B, MethodObj)
                    ^XQ0B ()
                }
            }
            
            // Fn + F5
            Method (_Q0E)
            {
                If (OSDW)
                {
                    If (\_SB.ATKP)
                    {
                        \_SB.ATKD.IANE (0x20)
                    }
                } Else
                {
                    // import original Ec Query
                    External (^XQ0E, MethodObj)
                    ^XQ0E ()
                }
            }
            
            // Fn + F6
            Method (_Q0F)
            {
                If (OSDW)
                {
                    If (\_SB.ATKP)
                    {
                        \_SB.ATKD.IANE (0x10)
                    }
                } Else
                {
                    // import original Ec Query
                    External (^XQ0F, MethodObj)
                    ^XQ0F ()
                }
            }
            
            // End of EC Query Patch
        }
        
        // import external obj, and turn off GFX0 device state
        External (GFX0, DeviceObj)
        Scope (GFX0)
        {
            If (OSDW)
            {
                Name (_STA, Zero)
            }
        }
        
        // IGPU Framebuffer patch for Intel UHD 620
        Device (IGPU)
        {
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (OSDW ())
                {
                    Return (One)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer () { 0x03 })
                }

                Return (Package ()
                {                    
                    "hda-gfx",
                    Buffer ()
                    {
                        "onboard-1"
                    },
                    
                    "disable-agdc", 
                    Buffer ()
                    {
                         0x01, 0x00, 0x00, 0x00                           // ....
                    }, 

                    "force-online", 
                    Buffer ()
                    {
                         0x01, 0x00, 0x00, 0x00                           // ....
                    }, 

                    "device-id", 
                    Buffer ()
                    {
                         0x16, 0x59, 0x00, 0x00                           // .Y..
                    }, 

                    "AAPL,ig-platform-id", 
                    Buffer ()
                    {
                         0x00, 0x00, 0x16, 0x59                           // ...Y
                    }, 

                    "framebuffer-con1-enable", 
                    Buffer ()
                    {
                         0x01, 0x00, 0x00, 0x00                           // ....
                    }, 

                    "framebuffer-con1-type", 
                    Buffer ()
                    {
                         0x00, 0x08, 0x00, 0x00                           // ....
                    }, 

                    "framebuffer-con2-enable", 
                    Buffer ()
                    {
                         0x01, 0x00, 0x00, 0x00                           // ....
                    }, 

                    "framebuffer-con2-type", 
                    Buffer ()
                    {
                         0x00, 0x08, 0x00, 0x00                           // ....
                    }, 

                    "framebuffer-patch-enable", 
                    Buffer ()
                    {
                         0x01, 0x00, 0x00, 0x00                           // ....
                    }
                })
            }            
            
        }
        
        // import Optimus _OFF method to disable Nvidia GPU
        External (RP01.PEGP._OFF, MethodObj)
        Device (DGPU)
        {
            Name (_HID, "DGPU0000")
            Method (_STA)
            {
                If (OSDW)
                {
                    Return (One)
                } Else
                {
                    Return (Zero)
                }
            }
            
            Method (_INI)
            {
                If (CondRefOf (\_SB.PCI0.RP01.PEGP._OFF))
                {
                    If (OSDW)
                    {
                        \_SB.PCI0.RP01.PEGP._OFF ()
                    }
                }
            }
        }
        
        // import HDAS Obj, and turn it of
        External (HDAS, DeviceObj)
        Scope (HDAS)
        {
            Name (_STA, Zero)
        }
        
        // HDEF Audio Patch for ALC256 - layout 66
        Device (HDEF)
        {
            Name (_ADR, 0x001F0003)
            Method (_STA)
            {
                If (OSDW)
                {
                    Return (One)
                } Else
                {
                    Return (Zero)
                }
            }
            Method (_DSM, 4)
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer () { 0x03 })
                }
                
                Return (Package ()
                {                    
                    "layout-id",
                    Buffer ()
                    {
                        0x42, 0x00, 0x00, 0x00
                    },
                    
                    "hda-gfx",
                    Buffer ()
                    {
                        "onboard-1"
                    }
                })
            }
        }
        
        // import ETPD Obj, and patch custom CRS
        External (I2C1.ETPD, DeviceObj)
        Scope (I2C1.ETPD)
        {
            Method (_CRS)
            {
                Name (SBFX, ResourceTemplate ()
                {
                    I2cSerialBusV2 (0x0015, ControllerInitiated, 0x00061A80,
                        AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                })
                
                Name (SBFG, ResourceTemplate ()
                {
                    GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                        "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x55
                        }
                })
                
                If (OSDW)
                {
                    Return (ConcatenateResTemplate (SBFX, SBFG))
                } Else
                {
                    // import XCRS
                    External (^XCRS, MethodObj)
                    ^XCRS ()
                }
            }
        }
        
        // import XHC for USB mapping
        External (XHC, DeviceObj)
        Scope (XHC)
        {
            // import RHUB and turn it off
            External (RHUB, DeviceObj)
            Scope (RHUB)
            {
                If (OSDW)
                {
                    Name (_STA, Zero)
                }
            }
            
            // Custom USB Mapping
            Device (HAMS)
            {
                Name (_ADR, Zero)
                Method (_STA)
                {
                    If (OSDW)
                    {
                        Return (One)
                    } Else
                    {
                        Return (Zero)
                    }
                }
                Device (RHUB)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Device (HS01)
                    {
                        Name (_ADR, One)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            Zero, 
                            Zero, 
                            Zero
                        })
                    }

                    Device (HS02)
                    {
                        Name (_ADR, 0x02)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            Zero, 
                            Zero, 
                            Zero
                        })
                    }

                    Device (HS03)
                    {
                        Name (_ADR, 0x03)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            Zero, 
                            Zero, 
                            Zero
                        })
                    }

                    Device (HS04)
                    {
                        Name (_ADR, 0x04)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            Zero, 
                            Zero, 
                            Zero
                        })
                    }

                    Device (HS05)
                    {
                        Name (_ADR, 0x05)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                    }

                    Device (HS06)
                    {
                        Name (_ADR, 0x06)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                    }

                    Device (HS08)
                    {
                        Name (_ADR, 0x08)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                    }

                    Device (SS01)
                    {
                        Name (_ADR, 0x0D)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0x03, 
                            Zero, 
                            Zero
                        })
                    }

                    Device (SS03)
                    {
                        Name (_ADR, 0x0F)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0x0A, 
                            Zero, 
                            Zero
                        })
                    }

                    Device (SS04)
                    {
                        Name (_ADR, 0x10)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0x0A, 
                            Zero, 
                            Zero
                        })
                    }
                }
            }
        }
    }

    // END MAIN PATCH

    // MISC PATCH GOES HERE
    Scope (\_SB.PCI0)
    {
        // Add MCHC
        Device (MCHC)
        {
            Name (_ADR, Zero)
            Method (_STA)
            {
                If (OSDW)
                {
                    Return (One)
                } Else
                {
                    Return (Zero)
                }
            }
        }
        
        // import SBUS
        External (SBUS, DeviceObj)
        Scope (SBUS)
        {
            // BUS0 Patch in order to load AppleSMBusPCI
            Device (BUS0)
            {
                Name (_CID, "smbus")
                Name (_ADR, Zero)
                Method (_STA)
                {
                    If (OSDW)
                    {
                        Return (One)
                    } Else
                    {
                        Return (Zero)
                    }
                }
                
                Device (DVL0)
                {
                
                    Name (_ADR, 0x57)
                    Name (_CID, "diagsvault")
                    Method (_DSM, 4)
                    {
                        If (!Arg2)
                        {
                            Return (Buffer () { 0x57 })
                        }
                        
                        Return (Package (0x02)
                        {
                            "address",
                            0x57
                        })
                    }
                }
            }
        }
        
        Device (THML)
        {
            Name (_ADR, 0x00140002)
            Method (_STA)
            {
                If (OSDW)
                {
                    Return (One)
                } Else
                {
                    Return (Zero)
                }
            }
            Method (_DSM, 4)
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer () { 0x03 })
                }
                
                Return (Package ()
                {
                    "name",
                    Buffer ()
                    {
                        "PTCH"
                    },
                    
                    "AAPL,slot-name",
                    Buffer ()
                    {
                        "Built-in"
                    },
                    
                    "device_type",
                    Buffer ()
                    {
                        "Credit Patch"
                    },
                    
                    "model",
                    Buffer ()
                    {
                        "This patch created by Hamcuks. If you're facing problems, please contact me at t.me/hamcuks"
                    },
                    
                })
            }
        }
        
    }
    // END MISC PATCH
}