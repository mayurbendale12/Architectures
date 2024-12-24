import Foundation
import UIKit

public class CharacterLabelView: UIView {
    private let offset: CGFloat = 10
    private let fillColor: UIColor = .white

    public override func draw(_ rect: CGRect) {
        let path = UIBezierPath()

        path.move(to: CGPoint(x: bounds.minX + offset, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX - offset, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))

        path.close()
        fillColor.setFill()
        path.fill()
    }
}
