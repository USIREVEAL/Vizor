"
I am a status bar reporting all the metrics of the last hovered entity in textual format.
"
Class {
	#name : #VZMetricsBar,
	#superclass : #VZComponent,
	#instVars : [
		'metricsText'
	],
	#category : #'Vizor-GUI-Components'
}

{ #category : #specs }
VZMetricsBar class >> defaultLayout [
	^ SpBoxLayout newHorizontal
		add: #metricsText;
	yourself
]

{ #category : #initialization }
VZMetricsBar >> initialize [
	super initialize.
	
	self monitor announcer
		when: VZHoverEntityAnnouncement send: #whenSelectionChanged: to: self.

]

{ #category : #initialization }
VZMetricsBar >> initializePresenters [
	metricsText := self newLabel.
	
]

{ #category : #'private - utility' }
VZMetricsBar >> metricStringFrom: aVZMetric and: aValue [
	| aValueString |
	aValueString := (aValue isKindOf: Number)
		ifTrue: [ (aValue round: 1) printString ]
		ifFalse: [ aValue printString ].
	^ aVZMetric shortName , ': ' , aValueString.

]

{ #category : #dependencies }
VZMetricsBar >> release [
	self monitor announcer unsubscribe: self.
	
	super release.
]

{ #category : #'events-shortcuts' }
VZMetricsBar >> whenSelectionChanged: aVZEntityHoverAnnouncement [
	| metrics mappingClasses metricStrings string |
	metrics := aVZEntityHoverAnnouncement hoveredEntity metrics.
	mappingClasses := (aVZEntityHoverAnnouncement mappings collect: #key) asSet.
	metricStrings := OrderedCollection new.
	
	"Add metrics included in the mappings for the current view"
	metrics keysAndValuesDo: [ :metric :value |
		(mappingClasses includes: metric)
			ifTrue: [ metricStrings add: (self metricStringFrom: metric and: value) ] ].

	metricStrings sort.
	string := ', ' join: metricStrings.
	metricsText label: string.
]
