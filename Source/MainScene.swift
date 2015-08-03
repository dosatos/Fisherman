import Foundation

class MainScene: CCNode {
    
    weak var playButton: CCButton!
    
    func didLoadFromCCB() {
        
    }

    override func onEnter() {
        
    }
    
    func play() {
        let scene = CCBReader.loadAsScene("Gameplay/Gameplay")
        CCDirector.sharedDirector().presentScene(scene)
    }
}
