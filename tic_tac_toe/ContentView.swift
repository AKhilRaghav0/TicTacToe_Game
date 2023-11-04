//
//  ContentView.swift
//  tic_tac_toe
//
//  Created by Akhil on 04/11/23.
//

import SwiftUI


struct ContentView: View {
    
    let column: [GridItem] = [GridItem(.flexible()),
                              GridItem(.flexible()),
                              GridItem(.flexible()),]

    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled: Bool = false
//    @State private var isHumanTurn = true
    
    var body: some View {
        
        //using geometry reader to get approximate size on all screens
        GeometryReader { geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: column, spacing: 5){
                    ForEach(0..<9){ i in
                        ZStack{
                            Circle()
                                .foregroundColor(.red).opacity(0.6)
                                .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 15)

                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)


                        }
                        .onTapGesture{
                            if isSquareOccupied(in: moves, forIndex: i) {return}
                            moves[i] = Move(player: .human, boardIndex: i)
//                            isHumanTurn.toggle()
                            isGameboardDisabled = true
                            
                            //Check for Win condition or draw
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                let computerPosition = determineComputerMovePosition(in: moves)
                                
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameboardDisabled = false
                            }
                            
                        }
                        
                    }
                    
                }.disabled(isGameboardDisabled)
//                .padding()
                
                Spacer()
                
                
            }
            .padding()
            
            
            
        }
        
        
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?])-> Int {
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
}


enum Player {
    case human, computer
}



struct Move {
    let player:Player
    let boardIndex: Int
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
