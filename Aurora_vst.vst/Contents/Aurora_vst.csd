<Cabbage> bounds(0, 0, 0, 0)
form caption("Valkyrie"), size(870, 432), colour(58, 110, 182), pluginid("aur1")
image bounds(0, 0, 870, 432), file("background.png")
hslider bounds(236, 212, 398, 50), range(0, 6, 6, 1, 1), channel("indexday"), , popuptext("Day") trackercolour(11, 96, 38, 255)
rslider bounds(394, 306, 90, 61), range(0, 287, 0, 1, 1), , channel("indextime"), popuptext("Time")
;csoundoutput bounds(0, 432, 870, 300)
;csoundoutput bounds(0, 432, 870, 50)

label bounds(414, 214, 36, 14), text("DAY"), fontcolour(255, 255, 255, 255) alpha(0.85)
label bounds(178, 410, 520, 16) identchannel("timedisplay"), fontcolour(255, 255, 255, 255) alpha(0.7)

label bounds(586, 338, 100, 15), align("left"), identchannel("displayBt"), fontcolour(255, 255, 255, 255) alpha(0.75)
label bounds(520, 318, 100, 15), align("left"), identchannel("displayBx"), fontcolour(255, 255, 255, 255) alpha(0.75)
label bounds(586, 318, 100, 15), align("left"), identchannel("displayBy"), fontcolour(255, 255, 255, 255) alpha(0.75)
label bounds(654, 318, 100, 14), align("left"), identchannel("displayBz"), fontcolour(255, 255, 255, 255) alpha(0.75)
label bounds(616, 358, 100, 15), align("left"), identchannel("displayDens"), fontcolour(255, 255, 255, 255) alpha(0.75) 
label bounds(527, 358, 100, 15), align("left"), identchannel("displaySpeed"), fontcolour(255, 255, 255, 255) alpha(0.75)


</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
; Initialize the global variables.

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

gilisten OSCinit 9000

;***************************************************
;ftables

 ; classic waveforms
 giSine ftgen 0, 0, 65537, 10, 1 ; sine wave
 giCosine ftgen 0, 0, 8193, 9, 1, 1, 90 ; cosine wave
 giTri ftgen 0, 0, 8193, 7, 0, 2048, 1, 4096, -1, 2048, 0 ; triangle wave

 ; grain envelope tables
 giSigmoRise ftgen 0, 0, 8193, 19, 0.5, 1, 270, 1 ; rising sigmoid
 giSigmoFall ftgen 0, 0, 8193, 19, 0.5, 1, 90, 1 ; falling sigmoid
 giExpFall ftgen 0, 0, 8193, 5, 1, 8193, 0.00001 ; exponential decay
 giTriangleWin ftgen 0, 0, 8193, 7, 0, 4096, 1, 4096, 0 ; triangular window
;******************************************************


;***********************************
; Phaser UDO by Victor Lazzarini 2013
	opcode Phaser,a,akk
	setksmps 1
	ax,kfr,kR xin
	adel1 init 0
	adel2 init 0

	kR = 1/kR
	kthecos = cos((2*$M_PI*kfr)/sr);
	aa1 = -2*kR*kthecos;
	aa2 = kR*kR;
	ab1 = (-2/kR)*kthecos;
	ab2 = 1/aa2;

	aw = ax - ab1*adel1 - ab2*adel2
	ay = aw + aa1*adel1 + aa2*adel2

	adel2 = adel1
	adel1 = aw

	aout = ax + ay 	; combines original signal + allpass output so the destructive difference causes bump in spectrum
	xout aout

	endop
;***********************************

;***********************************
; Global Variables:
 gaPartikkel1 init 0
 gaPartikkel2 init 0
;***********************************


;; Route all midi to instrument 2
massign 0, 10

    instr  1

;--------  send osc message to python ----------;


        kTime chnget "indextime"
        kDay chnget "indexday"
        kDay = 6-kDay
        kFinalIndex = kTime + kDay*288
            OSCsend kFinalIndex, "127.0.0.1", 8000, "/index_from_csound", "i", kFinalIndex
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

            STimeStamp init ""
            ;nxtmsg:
            iPortTime = 0.1

                kcheck  OSClisten gilisten, "/Bt_med", "f", kBt_med
                kBt_med_port port kBt_med, iPortTime
                chnset  kBt_med_port,  "Bt_med"
                kcheck  OSClisten gilisten, "/Bt_min", "f", kBt_min
                chnset  kBt_min,  "Bt_min"
                kcheck  OSClisten gilisten, "/Bt_max", "f", kBt_max
                chnset  kBt_max, "Bt_max"

                kcheck  OSClisten gilisten, "/Bx_med", "f", kBx_med
                chnset  kBx_med,  "Bx_med"
                kcheck  OSClisten gilisten, "/Bx_min", "f", kBx_min
                chnset  kBx_min,  "Bx_min"
                kcheck  OSClisten gilisten, "/Bx_max", "f", kBx_max
                chnset  kBx_max,  "Bx_max"

                kcheck  OSClisten gilisten, "/By_med", "f", kBy_med
                chnset  kBy_med,  "By_med"
                kcheck  OSClisten gilisten, "/By_min", "f", kBy_min
                chnset  kBy_min,  "By_min"
                kcheck  OSClisten gilisten, "/By_max", "f", kBy_max
                chnset  kBy_max,  "By_max"

                kcheck  OSClisten gilisten, "/Bz_med", "f", kBz_med
                chnset  kBz_med,  "Bz_med"
                kcheck  OSClisten gilisten, "/Bz_min", "f", kBz_min
                chnset  kBz_min,  "Bz_min"
                kcheck  OSClisten gilisten, "/Bz_max", "f", kBz_max
                chnset  kBz_max,  "Bz_max"

                kcheck  OSClisten gilisten, "/Phi_med", "f", kPhi_med
                chnset  kPhi_med,  "Phi_med"
                kcheck  OSClisten gilisten, "/Phi_min", "f", kPhi_min
                chnset  kPhi_min,  "Phi_min"
                kcheck  OSClisten gilisten, "/Phi_max", "f", kPhi_max
                chnset  kPhi_max,  "Phi_max"

                kcheck  OSClisten gilisten, "/Theta_med", "f", kTheta_med
                chnset  kTheta_med,  "Theta_med"
                kcheck  OSClisten gilisten, "/Theta_min", "f", kTheta_min
                chnset  kTheta_min,  "Theta_min"
                kcheck  OSClisten gilisten, "/Theta_max", "f", kTheta_max
                chnset  kTheta_max,  "Theta_max"

                kcheck  OSClisten gilisten, "/Dens_med", "f", kDens_med
                kDens_med_port port kDens_med, iPortTime
                chnset  kDens_med_port,  "Dens_med"
                kcheck  OSClisten gilisten, "/Dens_min", "f", kDens_min
                chnset  kDens_min,  "Dens_min"
                kcheck  OSClisten gilisten, "/Dens_max", "f", kDens_max
                chnset  kDens_max,  "Dens_max"

                kcheck  OSClisten gilisten, "/Speed_med", "f", kSpeed_med
                kSpeed_med_port port kSpeed_med, iPortTime
                chnset  kSpeed_med_port,  "Speed_med"
                kcheck  OSClisten gilisten, "/Speed_min", "f", kSpeed_min
                chnset  kSpeed_min,  "Speed_min"
                kcheck  OSClisten gilisten, "/Speed_max", "f", kSpeed_max
                chnset  kSpeed_max,  "Speed_max"

                kcheck  OSClisten gilisten, "/Temp_med", "f", kTemp_med
                chnset  kTemp_med,  "Temp_med"
                kcheck  OSClisten gilisten, "/Temp_min", "f", kTemp_min
                chnset  kTemp_min,  "Temp_min"
                kcheck  OSClisten gilisten, "/Temp_max", "f", kTemp_max
                chnset  kTemp_max,  "Temp_max"
                printk2 kTemp_max
                kcheck  OSClisten gilisten, "/TimeStamp", "s", STimeStamp

                STimeDisplay sprintfk " text(\"%s\") ", STimeStamp
                chnset  STimeDisplay,  "timedisplay"
                
                
                STimeDisplay sprintfk " text(\"Bt: %i%s\") ", int(kBt_med*100), "%"
                chnset  STimeDisplay,  "displayBt"
                
                STimeDisplay sprintfk " text(\"Bx: %i%s\") ", int(kBx_med*100), "%"
                chnset  STimeDisplay,  "displayBx"
                
                STimeDisplay sprintfk " text(\"By: %i%s\") ", int(kBy_med*100), "%"
                chnset  STimeDisplay,  "displayBy"
                
                STimeDisplay sprintfk " text(\"Bz: %i%s\") ", int(kBz_med*100), "%"
                chnset  STimeDisplay,  "displayBz"
                
                STimeDisplay sprintfk " text(\"Density: %i%s\") ", int(kDens_med*100), "%"
                chnset  STimeDisplay,  "displayDens"
                
                STimeDisplay sprintfk " text(\"Speed: %i%s\") ", int(kSpeed_med*100), "%"
                chnset  STimeDisplay,  "displaySpeed"
endin



;**********************************************************************

; partikkel instr
instr 10


                kBt_med chnget  "Bt_med" ; Controls Reverb
                kBt_min chnget  "Bt_min"
                kBt_max chnget  "Bt_max"

                kBx_med  chnget  "Bx_med"
                kBx_min  chnget  "Bx_min"
                kBx_max  chnget  "Bx_max"

                kBy_med  chnget  "By_med"
                kBy_min  chnget  "By_min"
                kBy_max  chnget  "By_max"

                kBz_med  chnget  "Bz_med"
                kBz_min  chnget  "Bz_min"
                kBz_max  chnget  "Bz_max"

                kPhi_med  chnget  "Phi_med"
                kPhi_min  chnget  "Phi_min"
                kPhi_max  chnget  "Phi_max"

                kTheta_med  chnget  "Theta_med"
                kTheta_min  chnget  "Theta_min"
                kTheta_max  chnget  "Theta_max"

                kDens_med  chnget  "Dens_med"
                kDens_min  chnget  "Dens_min"
                kDens_max  chnget  "Dens_max"

                kSpeed_med  chnget  "Speed_med"
                kSpeed_min  chnget  "Speed_min"
                kSpeed_max  chnget  "Speed_max"

                kTemp_med  chnget  "Temp_med"
                kTemp_min  chnget  "Temp_min"
                kTemp_max  chnget  "Temp_max"




; select source waveform 1, (the other 3 waveforms can be set inside the include file partikkel_basic_settings.inc)
 kwaveform1 = giSine ; source audio waveform 1
 kwave1Single = 1 ; flag to set if waveform is single cycle (set to zero for sampled waveforms)

; ####################
;*******************************
; setup of source waveforms
; (needs to be done first, because grain pitch and time pointer depends on source waveform lengths)
;*******************************

; select source waveforms 2,3 and 4 (waveform 1 is selected outside of this include file, in the including instrument)
    kwaveform1  = giSine
	kwaveform2	= giSine		; source audio waveform 2
	kwaveform3	= giSine		; source audio waveform 3
	kwaveform4	= giSine		; source audio waveform 4

    kwave1Single    =1
	kwave2Single	= 1			; flag to set if waveform is single cycle (set to zero for sampled waveforms)
	kwave3Single	= 1			; flag to set if waveform is single cycle (set to zero for sampled waveforms)
	kwave4Single	= 1			; flag to set if waveform is single cycle (set to zero for sampled waveforms)

; get source waveform length (used when calculating transposition and time pointer)
	kfilen1		tableng	 kwaveform1		; get length of the first source waveform
	kfilen2		tableng	 kwaveform2		; same as above, for source waveform 2
	kfilen3		tableng	 kwaveform3		; same as above, for source waveform 3
	kfilen4		tableng	 kwaveform4		; same as above, for source waveform 4
	kfildur1	= kfilen1 / sr			; length in seconds, for the first source waveform
	kfildur2	= kfilen2 / sr			; same as above, for source waveform 2
	kfildur3	= kfilen3 / sr			; same as above, for source waveform 3
	kfildur4	= kfilen4 / sr			; same as above, for source waveform 4

; original pitch for each waveform, use if they should be transposed individually
; can also be used as a "cycles per second" parameter for single cycle waveforms (assuming that the kwavfreq parameter has a value of 1.0)
	kwavekey1	= 1
	kwavekey2	= 1
	kwavekey3	= 1
	kwavekey4	= 1


; time pointer (phase). This can be independent for each source waveform.
	isamplepos1	= 0				; initial phase for wave source 1
	isamplepos2	= 0				; initial phase for wave source 2
	isamplepos3	= 0				; initial phase for wave source 3
	isamplepos4	= 0				; initial phase for wave source 4

	kTimeRate	= 1				; time pointer rate
	asamplepos1	phasor kTimeRate / kfildur1	; phasor from 0 to 1, scaled to the length of the first source waveform
	asamplepos2	phasor kTimeRate / kfildur2	; same as above, scaled for source wave 2
	asamplepos3	phasor kTimeRate / kfildur3	; same as above, scaled for source wave 3
	asamplepos4	phasor kTimeRate / kfildur4	; same as above, scaled for source wave 4

	; mix initial phase and moving phase value (moving phase only for sampled waveforms, single cycle waveforms use static samplepos)
	;asamplepos1	= asamplepos1*(1-kwave1Single) + isamplepos1
	;asamplepos2	= asamplepos2*(1-kwave2Single) + isamplepos2
	;asamplepos3	= asamplepos3*(1-kwave3Single) + isamplepos3
	;asamplepos4	= asamplepos4*(1-kwave4Single) + isamplepos4

;*******************************
; other granular synthesis parameters
;*******************************

; amplitude
	kamp		= ampdbfs(-3)				; output amplitude

; sync
	async 		= 0.0					; set the sync input to zero (disable external sync)

; grain rate
	kGrainRate	= 12.0					; number of grains per second

; grain rate FM
	kGrFmFreq	= kGrainRate/4				; FM freq for modulating the grainrate
	kGrFmIndex	= 0.0					; FM index for modulating the grainrate (normally kept in a 0.0 to 1.0 range)
	iGrFmWave	= giSine				; FM waveform, for modulating the grainrate
	aGrFmSig	oscil kGrFmIndex, kGrFmFreq, iGrFmWave	; audio signal for frequency modulation of grain rate
	agrainrate	= kGrainRate + (aGrFmSig*kGrainRate)	; add the modulator signal to the grain rate signal

; distribution
	kdistribution	= 0.0						; grain random distribution in time
	idisttab	ftgentmp	0, 0, 16, 16, 1, 16, -10, 0	; probability distribution for random grain masking

; grain shape
	kGrainDur	= 2.5					; length of each grain relative to grain rate
	kduration	= (kGrainDur*1000)/kGrainRate		; grain dur in milliseconds, relative to grain rate

	ienv_attack	= giSigmoRise 				; grain attack shape (from table)
	ienv_decay	= giSigmoFall 				; grain decay shape (from table)
	ksustain_amount	= 0.0					; balance between enveloped time(attack+decay) and sustain level time, 0.0 = no time at sustain level
	ka_d_ratio	= 0.5					; balance between attack time and decay time, 0.0 = zero attack time and full decay time

	kenv2amt	= 0.0					; amount of secondary enveloping per grain (e.g. for fof synthesis)
	ienv2tab	= giExpFall 				; secondary grain shape (from table), enveloping the whole grain if used

; grain pitch (transpose, or "playback speed")
	kwavfreq	= 1					; transposition factor (playback speed) of audio inside grains,

; pitch sweep
	ksweepshape		= 0.5						; grain wave pitch sweep shape (sweep speed), 0.5 is linear sweep
	iwavfreqstarttab 	ftgentmp	0, 0, 16, -2, 0, 0,   1		; start freq scalers, per grain
	iwavfreqendtab		ftgentmp	0, 0, 16, -2, 0, 0,   1		; end freq scalers, per grain

; FM of grain pitch (playback speed)
	kPtchFmFreq	= 440							; FM freq, modulating waveform pitch
	kPtchFmIndex	= 0							; FM index, modulating waveform pitch
	iPtchFmWave	= giSine						; FM waveform, modulating waveform pitch
	ifmamptab	ftgentmp	0, 0, 16, -2, 0, 0,   1			; FM index scalers, per grain
	ifmenv		= giTriangleWin 					; FM index envelope, over each grain (from table)
	kPtchFmIndex	= kPtchFmIndex + (kPtchFmIndex*kPtchFmFreq*0.00001) 	; FM index scaling formula
	awavfm		oscil	kPtchFmIndex, kPtchFmFreq, iPtchFmWave		; Modulator signal for frequency modulation inside grain

; trainlet parameters
	icosine		= giCosine				; needs to be a cosine wave to create trainlets
	kTrainCps	= kGrainRate				; set cps equal to grain freq, creating a single cycle of a trainlet inside each grain
	knumpartials	= 7					; number of partials in trainlet
	kchroma		= 3					; chroma, falloff of partial amplitude towards sr/2

; masking
	; gain masking table, amplitude for individual grains
	igainmasks	ftgentmp	0, 0, 16, -2, 0, 0,   1

	; channel masking table, output routing for individual grains (zero based, a value of 0.0 routes to output 1)
	ichannelmasks	ftgentmp	0, 0, 16, -2,  0, 0,  0.5

	; random masking (muting) of individual grains
	krandommask	= 0

	; wave mix masking.
	; Set gain per source waveform per grain,
	; in groups of 5 amp values, reflecting source1, source2, source3, source4, and the 5th slot is for trainlet amplitude.
	iwaveamptab	ftgentmp	0, 0, 32, -2, 0, 0,   1,0,0,0,0

; system parameter
	imax_grains	= 100				; max number of grains per k-period

; ####################

; a selection of parameters to start experimentation with partikkel
 kamp = ampdbfs(-1) ; amp
 kgrainrate = 5 ; number of grains per second
 kwavfreq = 440 ; playback speed inside each grain
 kRelDur = 1 ; grain duration
 kduration = (kRelDur*1000)/kgrainrate ; grain dur in milliseconds, relative to grain rate
 ka_d_ratio = 0.5
 krandommask = 0.0 ; random muting of single grains
 asamplepos1 = 0;line 0, p3, 1 ;when commented out: let the default samplepos be used (defined in partikkel_basic_settings.inc)


 ;####################


 ;; Just testing:
 k11 = 0.5; kBt_med
 k12 = 0.5 ;kBt_med
 k13 = 0.5 ;kBt_med
 k15 = 0.5 ;kBt_med
 k16 = 0.5 ;kBt_med
 k17 = 0.5 ;kBt_med
 k18 = 0.5 ;kBt_med
 k19 = 0.5 ;kBt_med
 k20 = 0.5 ;kBt_med
 k21 = 0.5 ;kBt_med
 k22 = 0.5 ;kBt_med
 k23 = 0.5 ;kBt_med
 gkRateControl = 1


 ;; Pitch of tone is controlled by midi note played
 iCpsMidi cpsmidi
 kwavfreq = iCpsMidi

 ;; Grainrate and duration
 kRelDur = (1-kDens_med)^7 *1.9 + 0.1
 kRelDurOscSpeed = (kDens_max)*6 + 0.1
 kRelDurOscAmp = (kDens_min)*0.5 + 0.05
 kRelDurOsc = oscil(kRelDurOscAmp, kRelDurOscSpeed) + 1
 kRelDur = kRelDur * kRelDurOsc


 kRateControl = gkRateControl
 kgrainrate = iCpsMidi * kRateControl
 kduration = (kRelDur*1000)/kgrainrate ; grain dur in milliseconds, relative to grain rate

 krandommask = (max(0, kBz_med-0.5)*1.7)^2
 ka_d_ration = kBz_med
 ;####################


a1,a2,a3,a4,a5,a6,a7,a8 partikkel \ ; (beginner)
 kgrainrate, \ ; grains per second *
 kdistribution, idisttab, async, \ ; synchronous/asynchronous
 kenv2amt, ienv2tab, ienv_attack, ienv_decay, \ ; grain envelope (advanced)
 ksustain_amount, ka_d_ratio, kduration, \ ; grain envelope *
 kamp, \ ; amp *
 igainmasks, \ ; gain masks (advanced)
 kwavfreq, \ ; grain pitch (playback frequency) *
 ksweepshape, iwavfreqstarttab, iwavfreqendtab, \ ; grain pith sweeps (advanced)
 awavfm, ifmamptab, ifmenv, \ ; grain pitch FM (advanced)
 icosine, kTrainCps, knumpartials, kchroma, \ ; trainlets
 ichannelmasks, \ ; channel mask (advanced)
 krandommask, \ ; random masking of single grains *
 kwaveform1, kwaveform2, kwaveform3, kwaveform4, \ ; set source waveforms * (using only waveform 1)
 iwaveamptab, \ ; mix source waveforms
 asamplepos1, asamplepos2, asamplepos3, asamplepos4, \ ; read position for source waves * (using only samplepos 1)
 kwavekey1, kwavekey2, kwavekey3, kwavekey4, \ ; individual transpose for each source
 imax_grains ; system parameter (advanced)


 ;; Amplitude modulation:
 ; NOTE: Bx for right, and By for left?
 kAM_freq = iCpsMidi * ((kBx_med*1.5) + 0.5)
 kAM_amp = 1
 aAM oscil kAM_amp, kAM_freq
 aAM = (aAM+kAM_amp)*0.5 ; Normalize over 0
 ;a1 = (a1*aAM*kBy_med) + (a1*(1-kBy_med))
 ;a2 = (a2*aAM*kBy_med) + (a2*(1-kBy_med))


 ;; Noise: (??) <- CONTROL
 aRandom rand 1
 kRandomMix = (kSpeed_med^0.2)*0.5+0.4
 kRandomFreq = iCpsMidi*0.5
 kRandomBandLFO = (oscil(0.5, (kSpeed_max-kSpeed_min)*100) + 0.5)
 kRandomBandControl = kRandomBandLFO * 0.01 + 0.01
 kRandomBand = kRandomFreq*kRandomBandControl*kSpeed_min
 kAmpFactor = kSpeed_max
 aRandom = \
    butbp(aRandom, kRandomFreq*1, kRandomBand*1) * kAmpFactor^0 + \
    butbp(aRandom, kRandomFreq*2, kRandomBand*2) * kAmpFactor^1 + \
    butbp(aRandom, kRandomFreq*3, kRandomBand*3) * kAmpFactor^2 + \
    butbp(aRandom, kRandomFreq*4, kRandomBand*4) * kAmpFactor^3 + \
    butbp(aRandom, kRandomFreq*5, kRandomBand*5) * kAmpFactor^4 + \
    butbp(aRandom, kRandomFreq*6, kRandomBand*6) * kAmpFactor^5 + \
    butbp(aRandom, kRandomFreq*7, kRandomBand*7) * kAmpFactor^6 + \
    butbp(aRandom, kRandomFreq*8, kRandomBand*8) * kAmpFactor^7

 aRandom *= 10
 a1 = ((a1*(1-kRandomMix)^0.5) + (aRandom*kRandomMix^0.5))
 a2 = ((a2*(1-kRandomMix)^0.5) + (aRandom*kRandomMix^0.5))


 ;; Chorus / Flanger: <- CONTROL
 kChorusMix = (kBt_max)^0.7*0.5 ;0.5 ; MAX:0.5, MIN:0.0
 kChorusOffset = (kBt_med^3*20)+0.01;20
 kChorusRate = kBt_med^2*5+0.1;0.4
 kChorusDepth = (kBt_min^3*kChorusOffset)+0.01;10
 iChorusTable = giSine
  aDelayTime1 oscili 0.5, kChorusRate, iChorusTable, 0 ; delay time oscillator (LFO)
  aDelayTime2 oscili 0.5, kChorusRate, iChorusTable, .5 ; delay time oscillator (LFO)
  aDelayTime1 = ((aDelayTime1+0.5)*kChorusDepth)+kChorusOffset ; scale and offset LFO
  aDelayTime2 = ((aDelayTime2+0.5)*kChorusDepth)+kChorusOffset ; scale and offset LFO
 aChorusL vdelayx a1, aDelayTime1*0.001, 1, 4
 aChorusR vdelayx a2, aDelayTime2*0.001, 1, 4
 a1 = ((a1*(1-kChorusMix)^0.5) + (aChorusL*kChorusMix^0.5))
 a2 = ((a2*(1-kChorusMix)^0.5) + (aChorusR*kChorusMix^0.5))




;; todo: Some volume scaling to compensate for reverb
;; ADSR
 adsr:
 kAdsrControl = tanh(((kBt_med + kDens_med) * 0.5)^3 * 100)
 kAttack = ((kAdsrControl^3)*0.50)+0.1
 iAttack = i(kAttack)
 iDecay = iAttack*0.4
 kSustain = (kAdsrControl)*0.3+0.7
 iSustain = i(kSustain)
 iRelease = iAttack*4
 if (iAttack == 0) then
    reinit adsr
 endif
 aAdsr expsegr 0.02, iAttack, 1, iDecay, iSustain, iRelease, 0.01
 a1 *= aAdsr
 a2 *= aAdsr


 ;; Distortion:
 ;kDistortion = 4 ;(k13^2)*10 + 1
 ;a1 = tanh(a1 * kDistortion) * (1/kDistortion)
 ;a2 = tanh(a2 * kDistortion) * (1/kDistortion)


 ;; Reverb:
 kReverb_level = (kBt_med^0.3)*0.75 + 0.2
 kReverb_cutoff = (kBt_min^0.4)*12000 + 1000
 kReverb_mix = kBt_max^0.1
 chnset kReverb_level, "Reverb_level"
 chnset kReverb_cutoff, "Reverb_cutoff"
 chnset kReverb_mix, "kReverb_mix"

 gaPartikkel1 += a1
 gaPartikkel2 += a2

endin
;**********************************************************************

instr 100  ;; mix and reverb

 kBz_med chnget "Bz_med"
 kBz_min chnget "Bz_min"
 kBz_max chnget "Bz_max"

 a1 = gaPartikkel1
 a2 = gaPartikkel2
 gaPartikkel1 = 0
 gaPartikkel2 = 0

 ;; Phaser: <- CONTROL
 kPhaserMix = tanh(1-kBz_max^2)
 kPhaserLowFreq = 100
 kPhaserRange = 5000
 kPhaserLFOFreq = (kBz_med-0.5)*3*-1
 kPhaserLFO oscil 0.5, kPhaserLFOFreq, giSigmoRise
 kPhaserFr = ((kPhaserLFO+0.5)*kPhaserRange)+kPhaserLowFreq
 kPhaserSharpness = (kBz_min^0.4)*0.4 + 0.5
 kPhaserScale = kPhaserSharpness*kPhaserSharpness*0.3 ; empirical scaling factor (Oeyvind)
 aPhaserL Phaser a1,kPhaserFr,kPhaserSharpness ; Allpass phaser UDO
 aPhaserR Phaser a2,kPhaserFr,kPhaserSharpness ; Allpass phaser UDO
 aPhaserL *= kPhaserScale
 aPhaserR *= kPhaserScale
 aPhaserL Phaser aPhaserL,kPhaserFr*2,kPhaserSharpness ; Allpass phaser UDO
 aPhaserR Phaser aPhaserR,kPhaserFr*2,kPhaserSharpness ; Allpass phaser UDO
 aPhaserL *= kPhaserScale
 aPhaserR *= kPhaserScale
 aPhaserL Phaser aPhaserL,kPhaserFr*4,kPhaserSharpness ; Allpass phaser UDO
 aPhaserR Phaser aPhaserR,kPhaserFr*4,kPhaserSharpness ; Allpass phaser UDO
 aPhaserL *= kPhaserScale
 aPhaserR *= kPhaserScale
 aPhaserL Phaser aPhaserL,kPhaserFr*8,kPhaserSharpness ; Allpass phaser UDO
 aPhaserR Phaser aPhaserR,kPhaserFr*8,kPhaserSharpness ; Allpass phaser UDO
 aPhaserL *= kPhaserScale
 aPhaserR *= kPhaserScale
 a1 = ((a1*(1-kPhaserMix)^0.5) + (aPhaserL*kPhaserMix^0.5))
 a2 = ((a2*(1-kPhaserMix)^0.5) + (aPhaserR*kPhaserMix^0.5))



 k0 = 0
 kReverb_level chnget "Reverb_level"
 chnset k0, "Reverb_level"
 kReverb_cutoff chnget "Reverb_cutoff"
 chnset k0, "Reverb_cutoff"
 kReverb_mix chnget "kReverb_mix"

 iReverbAmp = 0.7
 aReverbL, aReverbR reverbsc a1, a2, kReverb_level, kReverb_cutoff
 a1 = (a1*sqrt(1-kReverb_mix)) + (tanh(aReverbL * iReverbAmp) * sqrt(kReverb_mix))
 a2 = (a2*sqrt(1-kReverb_mix)) + (tanh(aReverbR * iReverbAmp) * sqrt(kReverb_mix))

 aOutL = a1
 aOutR = a2

 outs aOutL, aOutR

endin
;**********************************************************************


</CsInstruments>
<CsScore>
f0 z
i1 0 [60*60*24*7]

i100 0 36000000
</CsScore>
</CsoundSynthesizer>
