"
I am a hovering event.
I am fired when the user hovers over an entity in Vizor.
I know the entity from which the hover event was fired.
"
Class {
	#name : #VZHoverEntityAnnouncement,
	#superclass : #VZAnnouncement,
	#instVars : [
		'mappings',
		'hoveredEntity'
	],
	#category : #'Vizor-Core-Announcements'
}

{ #category : #accessing }
VZHoverEntityAnnouncement >> hoveredEntity [
	^ hoveredEntity
]

{ #category : #accessing }
VZHoverEntityAnnouncement >> hoveredEntity: aVZEntity [
	hoveredEntity := aVZEntity
]

{ #category : #accessing }
VZHoverEntityAnnouncement >> mappings [
	^ mappings
]

{ #category : #accessing }
VZHoverEntityAnnouncement >> mappings: anObject [
	mappings := anObject
]
