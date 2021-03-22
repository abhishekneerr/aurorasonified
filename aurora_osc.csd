<Cabbage>
form caption("Untitled") size(400, 300), colour(58, 110, 182), pluginid("def1")
keyboard bounds(8, 158, 381, 95)

rslider bounds(272, 34, 100, 100), channel("gain"), range(0, 11, 0, 1, 1), text("Gain"), trackercolour(0, 255, 0, 255), outlinecolour(0, 0, 0, 50), textcolour(0, 0, 0, 255)

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 


sr = 44100
ksmps = 100
nchnls = 2
0dbfs = 1

gilisten OSCinit 7000
;-------- instrument to receive OSC message from python -------;
;        instr   1
;        
;            kamp1 init 0
;            kamp2 init 0
;            kamp3 init 0
;            nxtmsg:
;                kcheck  OSClisten gilisten, "/osc_message_from_python1", "fff", kamp1, kamp2, kamp3
;            if (kcheck == 0) goto ex
;                printk 0,kamp1
;                printk 0,kamp2
;                printk 0,kamp3
;                kgoto nxtmsg
;            ex:     
;                endin
                

;
    instr  2
    
;--------  send osc message to python ----------;

        kGain chnget "gain"
        ;Sdata_time = "2021-01-27 00:00:00"
            OSCsend kGain, "127.0.0.1", 8000, "/osc_message_to_python", "f", kGain
;            printk 0, kGain
;            
;            
;-----------recieve------------
            kBt_med init 0
            kBt_min init 0
            kBt_max init 0
            
            kBx_med init 0
            kBx_min init 0
            kBx_max init 0
            
            kBy_med init 0
            kBy_min init 0
            kBy_max init 0
            
            kBz_med init 0
            kBz_min init 0
            kBz_max init 0
            
            kPhi_med init 0
            kPhi_min init 0
            kPhi_max init 0
            
            kTheta_med init 0
            kTheta_min init 0
            kTheta_max init 0
            
            kDens_med init 0
            kDens_min init 0
            kDens_max init 0
            
            kSpeed_med init 0
            kSpeed_min init 0
            kSpeed_max init 0
            
            kTemp_med init 0
            kTemp_min init 0
            kTemp_max init 0
            
            ;STimeStamp strcpy ""
            
            
            nxtmsg:
                
                kcheck  OSClisten gilisten, "/Bt_med", "f", kBt_med
                kcheck  OSClisten gilisten, "/Bt_min", "f", kBt_min
                kcheck  OSClisten gilisten, "/Bt_max", "f", kBt_max
                
                kcheck  OSClisten gilisten, "/Bx_med", "f", kBx_med
                kcheck  OSClisten gilisten, "/Bx_min", "f", kBx_min
                kcheck  OSClisten gilisten, "/Bx_max", "f", kBx_max
                
                kcheck  OSClisten gilisten, "/By_med", "f", kBy_med
                kcheck  OSClisten gilisten, "/By_min", "f", kBy_min
                kcheck  OSClisten gilisten, "/By_max", "f", kBy_max
                
                kcheck  OSClisten gilisten, "/Bz_med", "f", kBz_med
                kcheck  OSClisten gilisten, "/Bz_min", "f", kBz_min
                kcheck  OSClisten gilisten, "/Bz_max", "f", kBz_max
                
                kcheck  OSClisten gilisten, "/Phi_med", "f", kPhi_med
                kcheck  OSClisten gilisten, "/Phi_min", "f", kPhi_min
                kcheck  OSClisten gilisten, "/Phi_max", "f", kPhi_max
                
                kcheck  OSClisten gilisten, "/Theta_med", "f", kTheta_med
                kcheck  OSClisten gilisten, "/Theta_min", "f", kTheta_min
                kcheck  OSClisten gilisten, "/Theta_max", "f", kTheta_max
                
                kcheck  OSClisten gilisten, "/Dens_med", "f", kDens_med
                kcheck  OSClisten gilisten, "/Dens_min", "f", kDens_min
                kcheck  OSClisten gilisten, "/Dens_max", "f", kDens_max
                
                kcheck  OSClisten gilisten, "/Speed_med", "f", kSpeed_med
                kcheck  OSClisten gilisten, "/Speed_min", "f", kSpeed_min
                kcheck  OSClisten gilisten, "/Speed_max", "f", kSpeed_max
                
                kcheck  OSClisten gilisten, "/Temp_med", "f", kTemp_med
                kcheck  OSClisten gilisten, "/Temp_min", "f", kTemp_min
                kcheck  OSClisten gilisten, "/Temp_max", "f", kTemp_max
                
                ;kcheck  OSClisten gilisten, "/TimeStamp", "s", STimeStamp
                
                
            if (kcheck == 0) goto ex
                
                printk 0,kBt_med
                printk 0,kBt_min
                printk 0,kBt_max
                ;sprintfk 0,STimeStamp
                
                kgoto nxtmsg
            ex:     
                endin 
</CsInstruments>
<CsScore>
f0 z
;f 1 0 1024 10 1
;i 1 0 [60*60*24*7]
i 2 0 [60*60*24*7]
</CsScore>
</CsoundSynthesizer>

        