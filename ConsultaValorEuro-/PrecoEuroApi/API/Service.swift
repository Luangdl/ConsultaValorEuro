////
////  Service.swift
////  PrecoEuroApi
////
////  Created by Luan.Lima on 20/04/22.
////
//
import Foundation


enum Error1: Error, LocalizedError {
    case falhaAoProcessarRequisicao(Error)
    case falhaAoObterResposta
    case dadosInvalidos
}

class Service {
    
    var url = "https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL"
   
    private var session = URLSession.shared
    private let decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    private var dataTask: URLSessionDataTask?
    
    func listaTodos(completionHandler: @escaping (Currencies) -> Void,
                    failureHandler: @escaping (Error1) -> Void) {
        dataTask?.cancel()
        
        let url = URL(string: url)!
        
        dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                DispatchQueue.main.async
                {
                    failureHandler(.falhaAoProcessarRequisicao(error))
                }
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                DispatchQueue.main.async {
                    failureHandler(.falhaAoObterResposta)
                }
                return
            }
                
            do {
                guard let self = self else { return }
                
                let currencies = try self.decoder.decode(Currencies.self, from: data)
                
                DispatchQueue.main.async {
                    completionHandler(currencies)
                }
                
            } catch let error {
                DispatchQueue.main.async {
                   print(error)
                    failureHandler(.dadosInvalidos)
                }
            }
        }
        
        dataTask?.resume()
    }
    
}

