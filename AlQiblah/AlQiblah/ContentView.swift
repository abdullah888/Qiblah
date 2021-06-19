//
//  ContentView.swift
//  AlQiblah
//
//  Created by abdullah FH  on 09/11/1442 AH.
//


import Foundation
import SwiftUI

struct Marker: Hashable {
    let degrees: Double
    let label: String
    

    init(degrees: Double, label: String = "") {
        self.degrees = degrees
        self.label = label
    }

    func degreeText() -> String {
        return String(format: "", self.degrees)
    }

    static func markers() -> [Marker] {
        return [
          
            Marker(degrees: 270, label: ""),
          
        ]
    }
}

struct CompassMarkerView: View {
    let marker: Marker
    let compassDegress: Double

    var body: some View {
        VStack {
            Text(marker.degreeText())
                .fontWeight(.light)
                .rotationEffect(self.textAngle())
            
            Image("Alkaaba")
                .resizable()
                .frame(width: 50, height: 50)
               
            Text(marker.label)
                .fontWeight(.bold)
                .rotationEffect(self.textAngle())
                .padding(.bottom, 180)
        }.rotationEffect(Angle(degrees: marker.degrees))
    }
    
    private func capsuleWidth() -> CGFloat {
        return self.marker.degrees == 0 ? 7 : 3
    }

    private func capsuleHeight() -> CGFloat {
        return self.marker.degrees == 0 ? 45 : 30
    }

    private func capsuleColor() -> Color {
        return self.marker.degrees == 0 ? .red : .gray
    }

    private func textAngle() -> Angle {
        return Angle(degrees: -self.compassDegress - self.marker.degrees)
    }
}

struct ContentView : View {
    @ObservedObject var compassHeading = CompassHeading()
    @ObservedObject var distanceNorth = DistanceNorth()
    @ObservedObject var localSolarTime = LocalSolarTime()

    var body: some View {
        VStack {
            VStack{
            Text("\(localSolarTime.localSolarTime)")
                .font(.largeTitle)
                .background(Color.primary.opacity(0.06)
                .frame(width: UIScreen.main.bounds.width - 30,height: 100)
                .cornerRadius(25))
            }
            .padding(30)
            Spacer()
            ZStack {
                ForEach(Marker.markers(), id: \.self) { marker in
                    CompassMarkerView(marker: marker,
                                      compassDegress: self.compassHeading.degrees)
                }
            }
            .frame(width: 300, height: 300)
            .rotationEffect(Angle(degrees: self.compassHeading.degrees))
            .statusBar(hidden: true)
            Spacer()
            Image("kaaba")
                .resizable()
                .frame(width: 100, height: 100)
            Text("المسافه المتبقة")
                .font(.title2)
            Text("\(self.distanceNorth.meterDistance) km").font(.largeTitle)
                .foregroundColor(.red)
            
        }
    }
}
