**Other**<br/>
[Mapview](#mapview)<br/>
[Webview](#webview)<br/>
[Pagedimage](#pagedimage)<br/>
[Object](#object)<br/>



## Other

### <a name="mapview"></a> Mapview row
![Mapview row](https://github.com/rheoli/formotion/wiki/row-types/Mapview.png)
```ruby
{
  title: "Map",
  type: :mapview,
  value: coordinates,  # of type CLLocationCoordinate2D
  row_height: 200      # for better viewing
}
```

Shows a map with a pin at the coordinates from value.


### <a name="webview"></a> Webview row
![Webview row](https://github.com/rheoli/formotion/wiki/row-types/Webview.png)
```ruby
{
  title: "Page",
  type: :webview,
  value: html,      # HTML code to be shown
  row_height: 200   # for better viewing
}
```

### <a name="pagedimage"></a> Pagedimage row
![Pagedimage row](https://github.com/rheoli/formotion/wiki/row-types/Pagedimage.pngg)
```ruby
{
  title: "Photos",
  type: :pagedimage,
  value: images,      # array of UIImage's
  row_height: 200     # for better viewing
}
```

### <a name="object"></a> Object row

```ruby
{
  title: "My Data",
  type: :object,
  value: object       # an object
}
```

Same as StringRow with the difference that it would not change the row.value to string.