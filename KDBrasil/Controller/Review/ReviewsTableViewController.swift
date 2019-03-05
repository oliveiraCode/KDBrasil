//
//  ReviewsTableViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-04.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

class ReviewsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var cvRating: CosmosView!
    @IBOutlet weak var lbCountRating: UILabel!
    @IBOutlet weak var btnReview: UIButton!
    
    var business = Business()
    var myReview:[Review]? = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func updateUI(){
        
        btnReview.layer.borderColor = UIColor.blue.cgColor
        btnReview.layer.borderWidth = 0.5
        btnReview.layer.cornerRadius = btnReview.bounds.height / 2
        btnReview.clipsToBounds = true
        
        
        guard let reviews = self.business.reviews else {return}
        self.cvRating.settings.fillMode = .half
        self.lbRating.text =   "\(Service.shared.calculateRating(reviews: reviews))"
        self.cvRating.rating = Service.shared.calculateRating(reviews: reviews)
        
        
        if self.business.reviews!.count <= 1  {
            self.lbCountRating.text = "(\(reviews.count)) comentário"
        } else {
            self.lbCountRating.text = "(\(reviews.count)) comentários"
        }
        
        for (index, value) in reviews.enumerated() {
            if value.user_id == appDelegate.userObj.id {
                myReview = [reviews[index]]
                self.business.reviews?.remove(at: index)
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Meu comentário"
        } else {
            return "Todos os comentários (\(self.business.reviews?.count ?? 0))"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            return self.myReview?.count ?? 0
        } else {
            return self.business.reviews?.count ?? 0
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewsTableViewCell
        
        guard let reviews = self.business.reviews else {return cell}
        
        if indexPath.section == 0 {
            cell.lbTitle.text = myReview![indexPath.row].title
            cell.cvRating.rating = myReview![indexPath.row].rating!
            cell.lbRating.text = "\(myReview![indexPath.row].rating!)"
            cell.lbDescription.text = myReview![indexPath.row].description
            cell.lbDate_review.text = "\(myReview?[indexPath.row].user_name!) \(myReview![indexPath.row].date_review!)"
        }
        
        if indexPath.section == 1 {
            cell.lbTitle.text = reviews[indexPath.row].title
            cell.cvRating.rating = reviews[indexPath.row].rating!
            cell.lbRating.text = "\(reviews[indexPath.row].rating!)"
            cell.lbDescription.text = reviews[indexPath.row].description
            cell.lbDate_review.text = "\(reviews[indexPath.row].user_name!) \(reviews[indexPath.row].date_review!)"
            
        }
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        if indexPath.section == 0 {
            return true
        }
        return false
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        

        
        let deleteAction = UIContextualAction(style: .destructive, title: "Deletar") { (contextualAction, view, success) in
            
    
//            for (index, value) in self.business.reviews!.enumerated() {
//                if value.user_id == self.appDelegate.userObj.id {
//                    self.myReview?.removeAll()
//                    self.business.reviews?.remove(at: index)
//                    tableView.deleteRows(at: [indexPath], with: .fade)
//                    tableView.reloadData()
//                    break
//                }
//            }
//            
            
            
        //    FIRFirestoreService.shared.updateReviewData(business: self.business)
            
            self.myReview?.removeAll()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            print("indexPath \(indexPath)")
            success(true)
        }
        
        
        let editAction = UIContextualAction(style: .normal, title: "Editar") { (contextualAction, view, success) in
            
           // self.businessIndexPathSelected = indexPath.row
          //  self.performSegue(withIdentifier: "showEditBusinessVC", sender: nil)
            
            success(false)
        }
        
        
        //set color and image
        deleteAction.image = UIImage(named: "trash")
        deleteAction.backgroundColor = .red
        editAction.image = UIImage(named: "edit_business")
        editAction.backgroundColor = .blue
        
        
        return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    }
    
    
    
    @IBAction func btnReviews(_ sender: UIButton) {
        
        if appDelegate.userObj.id == nil {
            
            let alert = UIAlertController(title: "", message: CommonWarning.errorNewReviews, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: LocalizationKeys.buttonCancel, style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: LocalizationKeys.buttonLogin, style: .default, handler: { action in
                self.performSegue(withIdentifier: "showLoginVC", sender: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            performSegue(withIdentifier: "showReviewVC", sender: nil)
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showReviewVC" {
            let navController = segue.destination as! UINavigationController
            let destController = navController.topViewController as! MyReviewViewController
            destController.business = business
        }
        
        
    }
    
    
}
