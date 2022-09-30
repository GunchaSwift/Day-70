# Day-70
### **Bucket List project part 3**

***Adding custom locations to a map***

To create custom locations we must create a structure that holds all neccessary information. In addition, this struct must conform to three protocols:

1. Identifiable, so we can create many location markers in our map (id required);
2. Codable, so we can load an save map data easily (storing latitude and longitude seperately gives this to us for free);
3. Equatable, so we can find one particular location in an array of location.

```
struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}
```

Next, in our ContentView we must store Locations in an array. Then, when, for example, button is tapped - we create new location and append it to the array.

Finally, in our MapView we add annotationItems and pass in them in the closure.

***Improving map annotations***

SwiftUI makes it really simple to use custom annotations. Instead of MapMarker just use MapAnnotation and add custom design.

```
MapAnnotation(coordinate: location.coordinate) {
  VStack {
    Image(systemName: "star.circle")
      .resizable()
      .foregroundColor(.red)
      .frame(width: 44, height: 44)
      .background(.white)
      .clipShape(Circle())
                        
    Text(location.name)
  }
}
```

There are three things we can do about our code to make it better:

1. Add computed property to calculate CLLocationCoordinate2D inside our struct so we dont lose conformance to Codable and we dont have to calculate coordinates inside UI.
2. Add example data to our struct, which make it better for previews.
3. Add custom == func in our struct, which can compare two ids and tell right away that those places are equal.

***Selecting and editing map annotations***

In this case we're using only one @State property to either show or hide .sheet:

```
@State private var selectedPlace: Location?
```

This means we might have or might not have selectedPlace, and that's all SwiftUI needs to know in order to present a sheet.

Inside a sheet we need to present our EditView. This might seem easy, but there are few problems we're facing here:

1. What are the initial values for name and description?
2. How do we pass the new location back, when editing is completed?

To solve the first problem, we must create custom initializer that accepts the location and uses that to create State structs using the location's data. Here we're using underscore approach, which allows us to create an instance of the property wrapper not the data inside the wrapper.

```
init(location: Location) {
    self.location = location

    _name = State(initialValue: location.name)
    _description = State(initialValue: location.description)
}
```

The other problem can be solved using @Binding, but that creates problems with our optional in ContentView. The simplest solution, according to Paul Hudson, is to call function where we pass back whatever location we want. This means any other SwiftUI can send us some data, and get back some new data to process however we want.

```
// Property in EditView
var onSave: (Location) -> Void


// Update our initializer
init(location: Location, onSave: @escaping (Location) -> Void) {
    self.location = location
    self.onSave = onSave

    _name = State(initialValue: location.name)
    _description = State(initialValue: location.description)
}
```

Remember, @escaping means that function is being stashed away for user later on, rather than being called immediately, and it is needed here because the onSave function will get called only when the user press Save button.

Speaking on which, we need to update Save button as well.

```
Button("Save") {
    var newLocation = location
    newLocation.name = name
    newLocation.description = description

    onSave(newLocation)
    dismiss()
}
```

With this our EditView is completed. To show it in sheet, update .sheet code with this:

```
EditView(location: place) { newLocation in
    if let index = locations.firstIndex(of: place) {
        locations[index] = newLocation
    }
}
```

There are last 2 issues our project has - one is that saving doesn't actually save the new location, and the other is that with longer name string, the label will be clipped. Clipping can be solved simply by adding .fixedSize() modifier on that element, which will force any view to be given its natuarl size rather than trying to accomodate the amount of space offered by its parent.

Saving problem is being caused by our actions in Location structure - we told SwiftUI that two places were identical if their IDs were identical, and that isn't true anymore. When we update a marker, it now has a different name, but SwiftUI will compare IDs, therefore, not bother to change the map. To fix this, we must make id property mutable (from let to var) and generate new id when creating new location.

```
var newLocation = location
newLocation.id = UUID()
newLocation.name = name
newLocation.description = description
```
