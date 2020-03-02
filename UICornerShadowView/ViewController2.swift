//
//  ViewController2.swift
//  UICornerShadowView
//
//  Created by Jiang on 2020/2/13.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

import UIKit
import SFImageMaker
class ReuseImageCell: UITableViewCell{
    @IBOutlet weak var container: SFCSBView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.container.shadowColor = UIColor.black.withAlphaComponent(0.6)
        self.container.shadowRadius = 10
        self.container.cornerRadius = 10
        self.container.borderWidth = 0
    }
    func topStyle(){
        self.container.shadowPosition = [.left,.right,.top]
        self.container.rectCornner = [.topLeft,.topRight]
    }
    func middleStyle(){
        self.container.shadowPosition = [.left,.right]
        self.container.rectCornner = UIRectCorner.init(rawValue: 0)
    }
    func bottomStyle(){
        self.container.shadowPosition = [.left,.right,.bottom]
        self.container.rectCornner = [.bottomRight,.bottomLeft]
    }
}
class ViewController2: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 20))
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 20))
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseImageCell") as! ReuseImageCell
        let totalCount = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == 0{
            cell.topStyle()
        }
        if indexPath.row == totalCount - 1{
            cell.bottomStyle()
        }
        if indexPath.row > 0 && indexPath.row < totalCount - 1{
            cell.middleStyle()
        }
        cell.container.reloadBackGourndImage()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReuseImageCell
//        let alert = UIAlertController.init(title: "DebugInfo", message: cell.container.debugInfo(), preferredStyle: .alert)
//        alert.addAction(UIAlertAction.init(title: "cancel", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

