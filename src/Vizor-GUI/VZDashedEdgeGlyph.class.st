"
I am a glyph that represents a VZFriendshipEdge.
"
Class {
	#name : #VZDashedEdgeGlyph,
	#superclass : #VZEdgeGlyph,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #rendering }
VZDashedEdgeGlyph >> shapeForRoassal [
	^ RSLine new dashed
]
