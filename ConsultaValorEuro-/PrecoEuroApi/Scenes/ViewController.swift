//
//  ViewController.swift
//  PrecoEuroApi
//
//  Created by Luan.Lima on 19/04/22.
//
import TransitionButton
import UIKit

class ViewController: UIViewController {
    
    var currencies: Currencies?
    
    // MARK: Dependencie
    
    private let service = Service()
    
    //MARK: UIView
    
    private lazy var button: TransitionButton = {
        let button = TransitionButton(frame: CGRect(x: 0, y: 0, width: 180, height: 50))
        button.setTitle("Consultar", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(didTapView), for: .touchUpInside)
        button.spinnerColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var imagem: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "euro")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var eurValue: UILabel = {
        let label = UILabel()
        label.text = "R$ 0.00"
        label.font = label.font.withSize(40)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imagem, eurValue, button])
        stack.spacing = 16
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: Functions
    
    @objc func didTapView() {
        updateEuroValue()
    }
    
    func alertaAction() {
        let alert = UIAlertController(title: "Erro ao consultar", message: "Tente novamente mais tarde.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(confirm)
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateEuroValue() {
        button.startAnimation()
        service.listaTodos(completionHandler: { [weak self] preco in
            self?.button.stopAnimation(animationStyle: .normal, revertAfterDelay: 1)
            self?.eurValue.text = preco.eurbrl.bid.currencyFormatting()
        }, failureHandler: { error in
            print(error)
                self.alertaAction()
        })
    }
}

//MARK: - ViewCode

extension ViewController: ViewCode {
    
    func buildViewHierarchy() {
        view.addSubview(containerStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([

            containerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
    }
    
}
