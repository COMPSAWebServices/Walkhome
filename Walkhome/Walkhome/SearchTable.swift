//
//  SearchTable.swift
//  Walkhome
//
//  Created by Raymond Chung on 2016-07-31.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import UIKit
import MapKit

class SearchTable: UITableViewController {
    var matches: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSearch? = nil
    var filteredSearch = [String]()
    
    func parseAddress(selected: MKPlacemark) -> String {
        let spaceBTWnumAddress = (selected.subThoroughfare != nil && selected.thoroughfare != nil) ? " " : ""
        let commaBTWstCity = (selected.subThoroughfare != nil || selected.thoroughfare != nil) && (selected.subAdministrativeArea != nil || selected.administrativeArea != nil) ? ", " : ""
        let spaceBTWcityProvince = (selected.subAdministrativeArea != nil && selected.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            selected.subThoroughfare ?? "",
            spaceBTWnumAddress,
            selected.thoroughfare ?? "",
            commaBTWstCity,
            selected.locality ?? "",
            spaceBTWcityProvince,
            selected.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension SearchTable : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let mapView = mapView, //guard upwraps the optional
            let searchBarText = searchController.searchBar.text else {return}
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBarText
        searchRequest.region = mapView.region
        let search = MKLocalSearch(request: searchRequest) //searching
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {return}
            self.matches = response.mapItems
            self.tableView.reloadData() //Updates the tableView
        }
    }
}

extension SearchTable {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selected = matches[indexPath.row].placemark
        handleMapSearchDelegate?.addPin(selected)
        dismissViewControllerAnimated(true, completion: nil)
    }
}