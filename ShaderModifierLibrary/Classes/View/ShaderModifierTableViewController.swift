//
//  ShaderModifierTableViewController.swift
//  ShaderModifierLibrary
//
//  Created by Dennis Ippel on 16/02/2019.
//  Copyright © 2019 Rozengain. All rights reserved.
//

import UIKit

class ShaderModifierTableViewController: UITableViewController {
    private var selectedShaderModifier: ShaderModifierEntity?
    
    var shaderDataSource: ShaderModifierDataSource? {
        didSet {
            reloadInputViews()
        }
    }
    var shaderModifierSelectionDelegate: ShaderModifierSelectionDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shaderDataSource?.shaderModifiers.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shaderModifierCell", for: indexPath)

        if let shaderModifier = shaderDataSource?.shaderModifiers[indexPath.row] {
            cell.textLabel?.text = shaderModifier.name
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedShaderModifier = shaderDataSource?.shaderModifiers[indexPath.row]
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true) {
                guard let modifier = self?.selectedShaderModifier else { return }
                self?.shaderModifierSelectionDelegate?.didSelect(shaderModifier: modifier)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameViewControllerSegue",
            let vc = segue.destination as? GameViewController,
            let selectedShaderModifier = selectedShaderModifier
        {
            vc.selectedShaderModifier = selectedShaderModifier
            self.selectedShaderModifier = nil
        } else {
            
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "gameViewControllerSegue",
            let _ = selectedShaderModifier {
            return true
        }
        return false
    }
}

protocol ShaderModifierSelectionDelegate {
    func didSelect(shaderModifier: ShaderModifierEntity)
}
