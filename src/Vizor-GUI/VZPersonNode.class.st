"
I am a simple node representing a person that can have VZFriendships.
"
Class {
	#name : #VZPersonNode,
	#superclass : #VZNode,
	#instVars : [
		'name'
	],
	#category : #'Vizor-GUI-Examples'
}

{ #category : #accessing }
VZPersonNode >> name [
	^ name
]

{ #category : #accessing }
VZPersonNode >> name: anObject [
	name := anObject
]

{ #category : #printing }
VZPersonNode >> printOn: aStream [
	super printOn: aStream.
	aStream << ' (' << self name << ')'.
]
