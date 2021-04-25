//
//  ViewController.swift
//  Lesson31Map
//
//  Created by Валерий Игнатьев on 23.04.21.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    var viewModel = ViewModel()
    
    //lazy - вдруг пользователь не разрешит использовать гео данные, так зачем держать в памяти менеджера
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        //Точность данных о местоположении, которые ваше приложение хочет получать. Достаточно и трех километров
        lm.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        //запрашиваем у пользователя доступ к его гео позиции (info.plist обязателен)
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    //Не забываем от карты протянуть к GestureRecognizer (распознавателю жестов) Outlet collection
    @IBAction func mapClicking(_ sender: UITapGestureRecognizer) {
        //получаем координаты с экрана
        let touchLocation = sender.location(in: mapView)
        //преобразовываем координаты экрана в координаты карты
        let mapLocation = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        let coorCLLocation = CLLocation.init(latitude: mapLocation.latitude, longitude: mapLocation.longitude)
        
        coorCLLocation.lookUpLocationName { address in
            self.viewModel.updateTitleOnMap(self.mapView, self.textField, to: coorCLLocation, with: address)
        }
    }
    
    @IBAction func locationClicking(_ sender: Any) {
        guard let currentLocation = locationManager.location else { return }
        
        currentLocation.lookUpLocationName { address in
            self.viewModel.updateLocationOnMap(self.mapView, self.textField, to: currentLocation, with: address)
        }
    }
    
    @IBAction func textFieldClicking(_ sender: UITextField) {
        guard let address = sender.text, address != "" else { return }
        viewModel.updatePlaceMark(mapView, textField, to: address)
    }
}