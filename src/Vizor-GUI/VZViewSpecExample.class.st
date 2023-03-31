"
I am an example application using Vizor.
I open a graph with nodes representig subclasses of Collection.
I map a nesting level metric to size and I use different shapes for top level classes and leaves.
"
Class {
	#name : #VZViewSpecExample,
	#superclass : #VZClassSubclassExample,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #specs }
VZViewSpecExample class >> defaultViewSpec [
	^ VZViewSpec new
		name: 'Circular view';
		layoutClass: RSClusterLayout;
		glyphMappings:
			{(VZRootNode -> VZCircleNodeGlyph).
			(VZLeafNode -> VZLabelNodeGlyph)}
]

{ #category : #'instance creation' }
VZViewSpecExample class >> open [
	<script>
	| view graph |

	graph := self createGraph.

	view := VZViewBuilder new
		graph: graph;
		viewSpec: self viewSpecs first;
		build.
	
	self new
		view: view;
		open.
]

{ #category : #accessing }
VZViewSpecExample class >> title [
	^ 'Class hierarchy with names'
]

{ #category : #specs }
VZViewSpecExample class >> viewSpecs [
	^ {
		self defaultViewSpec .
		self defaultViewSpec
			name: 'Force view';
			layoutClass: RSForceBasedLayout .
	} asOrderedCollection
]
