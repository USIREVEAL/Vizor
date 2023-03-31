"
I am an example application using Vizor.
I open a graph with a nodes representing people and edges representing social relations.
"
Class {
	#name : #VZSocialExample,
	#superclass : #VZApplicationExample,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #data }
VZSocialExample class >> friendshipsForPeople: people [
	^ people flatCollect: [ :person |
		(1 to: 2) collect: [ :n |
			| friend edge |
			friend := (people copyWithout: person) atRandom.
			edge := VZFriendshipEdge new
				node1: person;
				node2: friend;
				yourself.
			person edges add: edge.
			friend edges add: edge.
			edge
		]
	]
]

{ #category : #'instance creation' }
VZSocialExample class >> open [
	<script>
	| people friendships graph view app |
	people := self people.
	friendships := self friendshipsForPeople: people.
	
	graph := VZGraph new
		addNodes: people;
		addEdges: friendships;
		yourself.
	
	view := VZViewBuilder new
		graph: graph;
		viewSpec: self viewSpecs first;
		build.
	
	app := self new
		view: view;
		yourself.
	app open.
]

{ #category : #data }
VZSocialExample class >> people [
	^ { 
	'Leanne Graham' .
	'Ervin Howell' .
	'Clementine Bauch' .
	'Patricia Lebsack' .
	'Chelsey Dietrich' .
	'Mrs. Dennis Schulist' .
	'Kurtis Weissnat' .
	'Nicholas Runolfsdottir V' .
	'Glenna Reichert' .
	'Clementina DuBuque' } collect: [ :each |
		VZPersonNode new name: each. ]
]

{ #category : #accessing }
VZSocialExample class >> title [
	^ 'People random connections graph with custom nodes and glyphs'
]

{ #category : #specs }
VZSocialExample class >> viewSpecs [
	^ { VZViewSpec new
		name: 'Default view';
		layoutClass: RSCircleLayout;
		glyphMappings: {
			VZPersonNode -> VZCircleNodeGlyph .
			VZFriendshipEdge -> VZDashedEdgeGlyph . }.
		} asOrderedCollection.
]
