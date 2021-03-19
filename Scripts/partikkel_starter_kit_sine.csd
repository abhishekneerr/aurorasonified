<CsoundSynthesizer>
<CsOptions>
-odac1
-M 0
</CsOptions>
<CsInstruments>

  sr   = 44100
  ksmps   = 10
  nchnls   = 2
  0dbfs  = 1

  ;instr 1
  ;iCpsMidi cpsmidi
;
  ;turnoff2
  ;noteoff
;
  ;kTrigger init 1
  ;schedkwhen 1, 0, 12, 10, 0, -1, iCpsMidi
  ;kTrigger = 0
;
  ;endin


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


 gaPartikkel1 init 0
 gaPartikkel2 init 0
;******************************************************
; partikkel instr
instr 1

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


 k11 ctrl7 1, 11, 0, 1  ; Used for RelDur
 k11 init 0.5

 k12 ctrl7 1, 12, 0, 1 ; Used for grainrate
 k12 init 0.5

 k13 ctrl7   1, 13, 0, 1  ; Controls Distortion
 k13 init 0.5

 k14 ctrl7 1, 14, 0, 1 ; Controls AM
 k14 init 0.5

 k15 ctrl7 1, 15, 0, 1 ; Controls Reverb & ADSR
 k15 init 0.5


 ;; Pitch of tone is controlled by midi note played
 iCpsMidi cpsmidi
 kwavfreq = iCpsMidi

 ;; Grainrate and duration
 kRelDur = (k11^2)*1.9 + 0.1

 kRateControl = ((k12^2)*1.5+0.5)
 ;kRateControl = ((k12^2)*20+0.2)
 ;kgrainrate = (k11*iCpsMidi) + (kRateControl*(1-k11))
 kgrainrate = iCpsMidi * kRateControl
 kduration = (kRelDur*1000)/kgrainrate ; grain dur in milliseconds, relative to grain rate


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
 kAM_freq = iCpsMidi * ((k14*1.5) + 0.5)
 kAM_amp = 1
 aAM oscil kAM_amp, kAM_freq
 aAM = (aAM+kAM_amp)*0.5 ; Normalize over 0
 a1 = (a1*aAM*k14) + (a1*(1-k14))
 a2 = (a2*aAM*k14) + (a2*(1-k14))



 ;; Distortion:
 kDistortion = (k13^2)*10 + 1
 a1 = tanh(a1 * kDistortion) * (1/kDistortion)
 a2 = tanh(a2 * kDistortion) * (1/kDistortion)


 ;; Reverb:
 kReverb_level = (k15)*0.7 + 0.2
 kReverb_cutoff = (k15^3)*12000 + 1000
 chnset kReverb_level, "Reverb_level"
 chnset kReverb_cutoff, "Reverb_cutoff"
 chnset k15, "k15"


 adsr:
 ;; ADSR
 kAttack = ((k15^3)*0.50)+0.01
 iAttack = i(kAttack)
 iDecay = iAttack*0.3
 kSustain = (k15)*0.8+0.2
 iSustain = i(kSustain)
 iRelease = iAttack*4
 print iAttack
 print iDecay
 print iSustain
 print iRelease
 if (iAttack == 0) then
    reinit adsr
 endif
 ;xtratim iRelease
 ;aAdsr linsegr 0, iAttack, 1, iDecay, iSustain, iRelease, 0
 aAdsr expsegr 0.1, iAttack, 1, iDecay, iSustain, iRelease, 0.1

 a1 *= aAdsr * 0.8
 a2 *= aAdsr * 0.8

 gaPartikkel1 += a1
 gaPartikkel2 += a2

endin

instr 100  ;; Reverb

 a1 = gaPartikkel1
 a2 = gaPartikkel2
 gaPartikkel1 = 0
 gaPartikkel2 = 0
 ;printk2(rms(a1))

 k0 = 0
 kReverb_level chnget "Reverb_level"
 chnset k0, "Reverb_level"
 kReverb_cutoff chnget "Reverb_cutoff"
 chnset k0, "Reverb_cutoff"
 k15 chnget "k15"

 iReverbAmp = 0.7
 aReverbL, aReverbR reverbsc a1, a2, kReverb_level, kReverb_cutoff
 aOutL = (a1*(1-k15)) + (tanh(aReverbL * iReverbAmp) * k15)
 aOutR = (a2*(1-k15)) + (tanh(aReverbR * iReverbAmp) * k15)
 ;printk2 (rms(aOutL))

 ;; Volume: (Just while working)
 k18 init 0.5
 k18 ctrl7 1, 18, 0, 1
 aOutL *= k18
 aOutR *= k18

 outs aOutL, aOutR
endin

</CsInstruments>
<CsScore>
;  start  dur
;i1   0     10
i100 0 36000000
</CsScore>
</CsoundSynthesizer>
