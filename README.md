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
