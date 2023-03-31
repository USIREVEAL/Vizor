"
I am a node represented by a textual label.
"
Class {
	#name : #VZLabelNodeGlyph,
	#superclass : #VZNodeGlyph,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #rendering }
VZLabelNodeGlyph >> shapeForRoassal [
	^ RSLabel new
		border: (RSBorder new color: #blue; width: 10);
		text: self entity model printString.
]
