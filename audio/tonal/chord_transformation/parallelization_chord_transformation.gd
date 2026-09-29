class_name TonalAudioParallelizationChordTransformation
extends TonalAudioChordTransformation

func apply(chord : TonalAudioChord) -> void:
	var root : TonalAudioSemitone = chord.semitones.front()

	for semitone in chord.semitones:
		if semitone == root: continue

		var interval : int = posmod(semitone.semitone - root.semitone, 12)
		if interval == 4:
			semitone.transpose(-1)
			return
		elif interval == 3:
			semitone.transpose(1)
			return
