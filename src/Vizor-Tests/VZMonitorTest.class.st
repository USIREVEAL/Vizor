"
A VZMonitorTest is a test class for testing the behavior of VZMonitor
"
Class {
	#name : #VZMonitorTest,
	#superclass : #VZTestCase,
	#category : #'Vizor-Tests-Core-Announcements'
}

{ #category : #tests }
VZMonitorTest >> testAnnouncer [
	| monitor |
	monitor := VZMonitor new.
	
	self assert: monitor announcer isNotNil.
	self assert: (monitor announcer isKindOf: Announcer).
]
