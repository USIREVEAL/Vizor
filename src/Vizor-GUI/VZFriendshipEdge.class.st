"
I am a simple edge representing a friendship between two VZPersonNode.
"
Class {
	#name : #VZFriendshipEdge,
	#superclass : #VZEdge,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #printing }
VZFriendshipEdge >> printOn: aStream [
	super printOn: aStream.
	aStream << ' (' << self node1 printString << ' -> ' << self node2 printString << ')'.
]
