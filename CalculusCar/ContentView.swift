//
//  ContentView.swift
//  CalculusCar
//
//  Created by Luke Drushell on 11/28/22.
//


//OK BEFORE WE GET STARTED, ALL THE COMMENTS MAKE THIS LOOK MORE OVERWHELMING THAN IT REALLY IS, ITS ACTUALLY REALLY SHORT IN PRACTICE. ANYWAYS HAPPY READING :D

import SwiftUI

struct ContentView: View {
    
    //defining the global variables that the user interacts with:
    
        //this is the given side length from origin to the center of our circle
        @State var knownSide: Double = 20
        //this is the given position of the car, which was x=23, y=4
        @State var knownPos: (Double, Double) = (23, 4)
        //this is the given derivative of x
        @State var knownRateX: Double = 2
        //this is the outputs of the program, a z distance and derivative of z respectively
        @State var display: (Double, Double) = (0, 0)
    
    //-----------------------------------------------------------
    
    
    // The four following functions contain all of our calculations, broken up into four chunks called calculateC(), calculateAngle(), calculateZ(), rateOfY(), and rateOfZ(). These follow the neccessary steps from our original problem
    //P.S. calculateC() is not really neccesary, since in our problem that value is given (it's the circle's radius), but in other cases it may not be, so we will include it
    
    func calculateC() -> Double {
        //this function applies trig rules on known points to solve for a hypotenuse
        
        //defining our 2 positions in relation to the circles center
        let x = knownPos.0 - knownSide
        let y = knownPos.1
        
        //applies pythagorean theorum to solve for c's side length
        //this can be read as the typical "c = the square root of (a^2 + b^2)"
        let c = (x.squared() + y.squared()).squareRoot()
        
        //outputs these two values that we solved for
        return (c)
    }
    
    func calculateAngle() -> Double {
        //this function applies trig rules on known points to solve for an angle
        
        //we only need a hypotenuse and an opposite side length, as we will be using arcsin
        let y = knownPos.1
        let c = calculateC()
        
        //asin is the name our programming language uses for arcsin; we use arcsin to solve for an inner angle in our right triangle, then subtract that from pi to find adjecent angle, which is the angle in the overall larger body triangle
        let cAngle = .pi - asin(y / c)
        
        //outputs these two values that we solved for
        return (cAngle)
    }
    
    func calculateZ() -> Double {
        //grabbing 2 sides and an angle for law of cosines; we will later just use pythagorean theorum to solve for this side to keep it more consistent with the rest of my teams process, but this makes it more fun and was the original way I solved the problem
        
            //defines Side A as the given side from our problem
            let a = knownSide
            //uses the calculateC function we wrote above; then redefines it as side length B of our new trinagle, larger
            let b = calculateC()
            //uses the calculateAngle function we wrote above and calls it C, which is referring to angle C
            let C = calculateAngle()
        //--------------------------------------------------------
        
        //apply law of cosines to solve for the third side length
            //this can be read as the typical "z^2 = a^2 + b^2 - 2abcosC"
            let zSquared = (a.squared() + b.squared() - (2 * a * b * cos(C)))
            //outputs the square root of zSquared, which is simply Z
            return zSquared.squareRoot()
        //------------------------------------------------------
    }
    
    func rateOfY() -> Double {
        //uses the distance formula, then simplifies it and takes derivative to find dy/dt
        
        //grabs the car's x and y value in relation to the circle's center, and x's rate of change
        let x = knownPos.0 - knownSide
        let y = knownPos.1
        let dx = knownRateX
        
        //take derivative of distance formula [Z = sqrt(x^2 + y^2)] -> 0 = 0.5(2x*dx/dt + 2y*dy/dt)
        //simplify then rewrite for dy/dt: 0 = x*dx/dt + y*dy/dt -> dy/dt = -(x*dx/dt)/y
        let yRate = -(x*dx)/y
        
        //outputs our deriviative of y
        return yRate
    }
    
    func rateOfZ() -> Double {
        //redefining our large triangle as a single right triangle, to make solving for rate of change of the hypotenuse simpler; this requires distance formula
        
        //defining our 3 side lengths & given x rate, and uses the rateOfY() function we wrote to find that rate as well
        let x = knownPos.0
        let y = knownPos.1
        let z = display.0
        let dx = knownRateX
        let dy = rateOfY()
        
        //takes the derivative of the distance formula to solve for dz/dt
        //pre deriv:  Z = the square root of ( x^2 + y^2 )
        //post deriv: Z*dz/dt = 0.5( 2*x*dx + 2*y*dy )
        //deviding both sides by z will give us the formula for dz/dt, which is the equation below
        let zRate: Double = (0.5 * (2 * x * dx + 2 * y * dy)/z)
        
        //outputs the final rate of change of Z, the last piece of info we were solving for
        return zRate
    }
    
    var body: some View {
        NavigationStack {
            ScrollView() {
                
                //Displays two final values it solves for:
                VStack(alignment: .leading) {
                    Text("Distance of Z:   \(display.0)")
                    Text("Derivative of Z: \(display.1)")
                } .padding()
                .font(.headline)
                
                Divider()
                
                //These are the text boxes that the user can input their own side lengths to
                VStack {
                    CleanTextField(title: "Known Side", given: "ex: 20 ft", num: $knownSide)
                    CleanTextField(title: "Known Pos: X", given: "ex: 23 ft", num: $knownPos.0)
                    CleanTextField(title: "Known Pos: Y", given: "ex: 4 ft", num: $knownPos.1)
                    CleanTextField(title: "Known X Rate: dx/dt", given: "m/s", num: $knownRateX)
                }
                
                //this button calls the two general functions and sets the display at the top to show them
                Button {
                    withAnimation {
                        display.0 = calculateZ()
                        display.1 = rateOfZ()
                    }
                } label: {
                    Text("Calculate")
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(10)
                } .padding()
                
                
            } .navigationTitle("Rate of Z")
            .padding()
        }
    }
}

extension Double {
    // this just lets me add .squared() to the end of any number to square it
    func squared() -> Double {
        return pow(self, 2)
    }
}


//This just defines a preview so that I can see the app in live time while I make changes
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//just defining a nicer looking text box for where the user inputs their given values
struct CleanTextField: View {
    
    let title: String
    let given: String
    @Binding var num: Double
    
    var body: some View {
        VStack {
            HStack {
                Text(title + ":")
                    .foregroundColor(Color(uiColor:UIColor.lightGray))
                Spacer()
            }
            TextField(given, value: $num, format: .number)
                .keyboardType(.decimalPad)
                .padding(10)
                .background(.regularMaterial)
                .cornerRadius(10)
                .padding(.horizontal)
        } .padding(.vertical, 7)
    }
}


//you're still here?
//it's over
//go home
//go
