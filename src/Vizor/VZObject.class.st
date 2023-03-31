"
I am the root object class for Vizor.
"
Class {
	#name : #VZObject,
	#superclass : #Object,
	#category : #'Vizor-Base'
}

{ #category : #dependencies }
VZObject >> release [
	self class instVarNames do: [ :name | self instVarNamed: name put: nil ].
	
	('Released ' , self printString) traceCr.
	super release.
]
