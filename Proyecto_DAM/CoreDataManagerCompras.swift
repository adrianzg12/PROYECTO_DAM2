import Foundation
import CoreData

struct CoreDataManagerCompras {
    
    static let shared = CoreDataManagerCompras()
    
    private let context = PersistenceController.shared.viewContext
    
    func guardarArticulo(nombre: String, cantidad: Int32, prioridad: String, notas: String?, categoria: String, tiendas: [Tienda]) throws {
        let nuevoArticulo = Articulo(context: context)
        nuevoArticulo.id = UUID()
        nuevoArticulo.nombre = nombre
        nuevoArticulo.cantidad = cantidad
        nuevoArticulo.prioridad = prioridad
        nuevoArticulo.notas = notas
        nuevoArticulo.comprado = false
        nuevoArticulo.categoria = categoria
        
        nuevoArticulo.addToTiendas(NSSet(array: tiendas))
        
        try context.save()
    }


    func cargarArticulos() -> [Articulo]? {
        let fetchRequest: NSFetchRequest<Articulo> = Articulo.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error al cargar artículos: \(error)")
            return nil
        }
    }
    
    func eliminarArticulo(articulo: Articulo) throws {
        context.delete(articulo)
        try context.save()
    }
    
    func eliminarArticulosSeleccionados(articulosSeleccionados: [Articulo]) throws {
        for articulo in articulosSeleccionados {
            context.delete(articulo)
        }
        try context.save()
    }
    
    func marcarArticulosComprados(articulosSeleccionados: [Articulo]) throws {
        for articulo in articulosSeleccionados {
            articulo.comprado = true
        }
        try context.save()
    }
    
    func filtrarArticulos(categoria: String?, tienda: Tienda?) -> [Articulo]? {
        let fetchRequest: NSFetchRequest<Articulo> = Articulo.fetchRequest()
        var predicados: [NSPredicate] = []
        
        if let categoria = categoria {
            predicados.append(NSPredicate(format: "categoria == %@", categoria))
        }
        
        if let tienda = tienda {
            predicados.append(NSPredicate(format: "tienda == %@", tienda))
        }
        
        if !predicados.isEmpty {
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicados)
        }
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error al filtrar artículos: \(error)")
            return nil
        }
    }
    
    func obtenerTiendaPorNombre(nombre: String) throws -> Tienda? {
        let fetchRequest: NSFetchRequest<Tienda> = Tienda.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nombre == %@", nombre)
        
        do {
            let tiendas = try context.fetch(fetchRequest)
            return tiendas.first 
        } catch {
            throw error
        }
    }

}
