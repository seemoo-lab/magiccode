//
//  PairingAnimation.swift
//  VisualPair2
//
//  Created by Leon Böttger on 15.08.25.
//

import SwiftUI
import AVKit

struct PairingAnimation: View {
    
    @State var opacity = 0.0
    @State var player: AVPlayer?
    private let size: CGFloat
    
    @Environment(\.scenePhase) private var scenePhase
    
    init(size: CGFloat) {
        
        self.player = {
            guard let url = Bundle.main.url(forResource: "Loop-regular", withExtension: "mov") else {
                return nil
            }
            let player = AVPlayer(url: url)
            player.actionAtItemEnd = .none
            player.isMuted = true

            // Set audio session to avoid interrupting music
            try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .moviePlayback, options: [])
            try? AVAudioSession.sharedInstance().setActive(true)
            
            // Loop the video
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                player.seek(to: .zero)
                player.play()
            }
            
            player.play()
            
            return player
        }()
        self.size = size
    }
    
    var body: some View {
        if let player = player {
            VideoPlayer(player: player)
                .frame(width: size, height: size)
                .clipped()
                .opacity(opacity)
                .onChange(of: scenePhase) { newValue in
                    if newValue == .active {
                        player.play()
                    }
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        opacity = 1.0
                    }
                    
                    player.play()
                }
        }
    }
}

#Preview {
    PairingAnimation(size: 200)
}
