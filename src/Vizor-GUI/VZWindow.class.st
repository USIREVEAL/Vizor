"
I am a generic window.
"
Class {
	#name : #VZWindow,
	#superclass : #VZComponent,
	#category : #'Vizor-GUI-Components'
}

{ #category : #specs }
VZWindow class >> defaultTitle [
	^ 'Vizor untitled window'.
]

{ #category : #initialization }
VZWindow >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	self window title: self class defaultTitle.
]
