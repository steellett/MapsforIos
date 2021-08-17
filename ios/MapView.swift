//
//  MapView.swift
//  MapView
//
//  Created by Pavel on 17.08.2021.
//

import UIKit
import Foundation
import YandexMapsMobile
import CoreGraphics
import React

struct Point: Codable {
  let checkupId: String
  let clinicId: String
  let lat: Double
  let lon: Double
  let price: String
  var asDictionary : [String:Any] {
    return ["checkupId": checkupId,
            "clinicId": clinicId,
            "lat": lat,
            "lon": lon,
            "price": price,]
  }
}

@objc(MapView)
class MapView: UIView, YMKClusterListener, YMKClusterTapListener, YMKMapObjectTapListener {
 
  @objc var onPointPress: RCTBubblingEventBlock?
  @objc var onMapPress: RCTBubblingEventBlock?

  
  @objc var data: NSString  = "" {
    didSet {
      let jsonData = String(data).data(using: .utf8)!
      print(String(data))
      do {
        let rawPoints = try JSONDecoder().decode([Point].self, from: jsonData)
        setupPoints(points: rawPoints)
        
      } catch {
        print("can't parse json \(error)")
      }
      
    }
  }
  func onClusterAdded(with cluster: YMKCluster) {
    cluster.appearance.setIconWith(clusterImage(cluster.size))
    cluster.addClusterTapListener(with: self)
  }
  
  func onClusterTap(with cluster: YMKCluster) -> Bool {
    return true
  }
  
  var mapView = YMKMapView()
  
 // private var imageProvider = UIImage(named: "component-logo-default")
  private let FONT_SIZE: CGFloat = 15
  private let MARGIN_SIZE: CGFloat = 3
  private let STROKE_SIZE: CGFloat = 2
  
  @objc var zoom: NSInteger  = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    let map = mapView.mapWindow.map
    map.set2DMode(withEnable: true)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView() {
    self.bounds.size.height = RCTScreenSize().height + 10;
    mapView.frame = self.bounds
    
    addSubview(mapView)
  }
  
  private func setupPoints(points: [Point]) {
    let target: YMKPoint;
    if(points.isEmpty){
        // москва
       target = YMKPoint(latitude: 55.75222, longitude: 37.61556)
    } else {
      target = YMKPoint(latitude: points[0].lat, longitude: points[0].lon)
    }

    let cameraPosition = YMKCameraPosition(
      target: target,
      zoom: 10,
      azimuth: 0,
      tilt: 0
    )
    
    mapView.mapWindow.map.move(with: cameraPosition)
    let collection = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)
    
    for point in points {
      let placemark = collection.addPlacemark(with: YMKPoint(latitude: point.lat, longitude: point.lon), image: createImage(point.price))
      placemark.addTapListener(with: self)
      placemark.userData = point
    }
    
    collection.clusterPlacemarks(withClusterRadius: 60, minZoom: 10)
  }
  
  
  
  func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
    if let point = mapObject.userData as? Point {
      if onPointPress != nil {
        onPointPress!(point.asDictionary)
      }
      return true
    } else {
      if onMapPress != nil {
        onMapPress!(["longitude" : point.longitude, "latitude" : point.latitude])
      }
      return true
    }
  }
  

  func createImage(_ price: String) -> UIImage {
    let scale = UIScreen.main.scale
    let font = UIFont.systemFont(ofSize: FONT_SIZE * scale)
    let size = price.size(withAttributes: [NSAttributedString.Key.font: font])
    let padding: CGFloat = 20
    let cr : CGFloat = 30
    let triangleWidth: CGFloat = 10
    let triangleHeight: CGFloat = 10
    let rect = CGRect(origin: .zero, size: CGSize(width: size.width + padding * 2,
                                                  height: size.height + padding * 2 + triangleHeight))
    let iconSize = rect.size
    let textRect = rect.insetBy(dx: 20, dy: 20)
    
    
    UIGraphicsBeginImageContext(iconSize)
    let ctx = UIGraphicsGetCurrentContext()!
    ctx.setFillColor(UIColor(hex: "#0096ffff")!.cgColor)
    
    
    // top left
    ctx.move(to: CGPoint(x: rect.minX + cr, y: rect.minY))
    ctx.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY + cr), control: CGPoint(x: rect.minX, y: rect.minY))
    
    ctx.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cr - triangleHeight))
    ctx.addQuadCurve(to: CGPoint(x: rect.minX + cr, y: rect.maxY - triangleHeight), control: CGPoint(x: rect.minX, y: rect.maxY  - triangleHeight))
    
    // bottom right
    ctx.addLine(to: CGPoint(x: rect.maxX / 2 - triangleWidth , y: rect.maxY - triangleHeight ))
    ctx.addLine(to: CGPoint(x: rect.maxX / 2 , y: rect.maxY))
    ctx.addLine(to: CGPoint(x: rect.maxX / 2 + triangleWidth , y: rect.maxY - triangleHeight))
    
    ctx.addLine(to: CGPoint(x: rect.maxX - cr,
                            y: rect.maxY - triangleHeight ))
    ctx.addQuadCurve(to: CGPoint(x: rect.maxX,
                                 y: rect.maxY  - triangleHeight - cr ),
                     control: CGPoint(x: rect.maxX, y: rect.maxY  - triangleHeight))
    ctx.addLine(to: CGPoint(x: rect.maxX,
                            y: rect.minY + cr))
    ctx.addQuadCurve(to: CGPoint(x: rect.maxX - cr,
                                 y: rect.minY),
                     control: CGPoint(x: rect.maxX,
                                      y: rect.minY))
    ctx.closePath()
    
    ctx.setStrokeColor(UIColor.white.cgColor)
    ctx.setLineWidth(4)
    ctx.drawPath(using: .fillStroke)
    
    (price as NSString).draw(
      in: textRect,
      withAttributes: [
        NSAttributedString.Key.font: font,
        NSAttributedString.Key.foregroundColor: UIColor.white])
    
    return UIGraphicsGetImageFromCurrentImageContext()!
  }
  
  func clusterImage(_ clusterSize: UInt) -> UIImage {
    let scale = UIScreen.main.scale
    let text = (clusterSize as NSNumber).stringValue
    let font = UIFont.systemFont(ofSize: FONT_SIZE * scale)
    let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
    let textRadius = sqrt(size.height * size.height + size.width * size.width) / 2
    let internalRadius = textRadius + MARGIN_SIZE * scale
    let externalRadius = internalRadius + STROKE_SIZE * scale
    let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)
    
    UIGraphicsBeginImageContext(iconSize)
    let ctx = UIGraphicsGetCurrentContext()!
    
    ctx.setFillColor(UIColor(hex: "#0096ffff")!.cgColor)
    ctx.fillEllipse(in: CGRect(
                      origin: .zero,
                      size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)));
    
    ctx.setFillColor(UIColor.white.cgColor)
    ctx.fillEllipse(in: CGRect(
                      origin: CGPoint(x: externalRadius - internalRadius, y: externalRadius - internalRadius),
                      size: CGSize(width: 2 * internalRadius, height: 2 * internalRadius)));
    
    (text as NSString).draw(
      in: CGRect(
        origin: CGPoint(x: externalRadius - size.width / 2, y: externalRadius - size.height / 2),
        size: size),
      withAttributes: [
        NSAttributedString.Key.font: font,
        NSAttributedString.Key.foregroundColor: UIColor.black])
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    return image
  }
}


extension UIColor {
  public convenience init?(hex: String) {
    let r, g, b, a: CGFloat
    
    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      let hexColor = String(hex[start...])
      
      if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
          r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
          g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
          b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
          a = CGFloat(hexNumber & 0x000000ff) / 255
          
          self.init(red: r, green: g, blue: b, alpha: a)
          return
        }
      }
    }
    
    return nil
  }
}
