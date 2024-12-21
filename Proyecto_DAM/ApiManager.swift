import Alamofire
import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    
    // Fetch categorías
    func fetchCategorias(completion: @escaping ([String]?, Error?) -> Void) {
        let url = "http://localhost:9090/api/categories"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let json):
                print("Categorias response: \(json)")  // Para ver cómo es la respuesta de la API
                
                // Intenta convertir la respuesta en un array de diccionarios
                if let jsonArray = json as? [[String: Any]] {
                    // Extrae los nombres de las categorías
                    let nombresCategorias = jsonArray.compactMap { categoria -> String? in
                        return categoria["nombre"] as? String
                    }
                    completion(nombresCategorias, nil)
                } else {
                    completion(nil, NSError(domain: "APIError", code: 100, userInfo: [
                        NSLocalizedDescriptionKey: "La respuesta no es un array de objetos de categorías. Respuesta: \(json)"
                    ]))
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    
    func fetchTiendas(completion: @escaping ([String]?, Error?) -> Void) {
        let url = "http://localhost:9090/api/tiendas"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let json):
                print("Tiendas response: \(json)")  // Imprime la respuesta para ver cómo es el formato
                
                // Intenta convertir la respuesta en un array de diccionarios
                if let jsonArray = json as? [[String: Any]] {
                    // Extrae los nombres de las tiendas
                    let nombresTiendas = jsonArray.compactMap { tienda -> String? in
                        return tienda["nombre"] as? String
                    }
                    completion(nombresTiendas, nil)
                } else {
                    completion(nil, NSError(domain: "APIError", code: 100, userInfo: [
                        NSLocalizedDescriptionKey: "La respuesta no es un array de objetos de tiendas. Respuesta: \(json)"
                    ]))
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

}
