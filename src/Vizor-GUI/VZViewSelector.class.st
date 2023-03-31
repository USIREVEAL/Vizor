"
I am a selector for different views.
I know my linked view on which to change the display of elements.
I know of all the possible layout strategies that can be used in my linked view.
"
Class {
	#name : #VZViewSelector,
	#superclass : #VZComponent,
	#instVars : [
		'layoutsList',
		'linkedView'
	],
	#category : #'Vizor-GUI-Components'
}

{ #category : #specs }
VZViewSelector class >> defaultLayout [
	^ SpBoxLayout newHorizontal
		add: #layoutsList;
	yourself

]

{ #category : #initialization }
VZViewSelector >> initialize [
	super initialize.
	layoutsList := self newButton.
]

{ #category : #accessing }
VZViewSelector >> linkedView: anObject [
	linkedView := anObject
]
