import SwiftUI

struct ListaComprasView: View {
    @FetchRequest var articulos: FetchedResults<Articulo>
    
    @State private var articulosSeleccionados: Set<Articulo> = []
    @State private var categorias: [String] = []
    @State private var tiendas: [String] = []
    @State private var categoriaSeleccionada: String?
    @State private var tiendaSeleccionada: String?
    
    @State private var isAgregarArticuloPresented: Bool = false
    
    init() {
        self._articulos = FetchRequest(
            entity: Articulo.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Articulo.nombre, ascending: true)],
            predicate: nil
        )
    }
    
    var body: some View {
        VStack {
            HStack {
                Picker("Categoría", selection: $categoriaSeleccionada) {
                    Text("Categoría").tag(String?.none)
                    ForEach(categorias, id: \.self) { categoria in
                        Text(categoria).tag(categoria as String?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: categoriaSeleccionada) { _ in
                    actualizarFiltro()
                }

                Picker("Tienda", selection: $tiendaSeleccionada) {
                    Text("Tienda").tag(String?.none)
                    ForEach(tiendas, id: \.self) { tienda in
                        Text(tienda).tag(tienda as String?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: tiendaSeleccionada) { _ in
                    actualizarFiltro()
                }
            }
            .padding()

            List(articulos, id: \.self, selection: $articulosSeleccionados) { articulo in
                NavigationLink(destination: EditarArticuloView(articulo: Binding(
                    get: { articulo },
                    set: { nuevoArticulo in
                        do {
                            if let tienda = try? CoreDataManagerCompras.shared.obtenerTiendaPorNombre(nombre: nuevoArticulo.tienda ?? "") {
                                try CoreDataManagerCompras.shared.guardarArticulo(
                                    nombre: nuevoArticulo.nombre ?? "",
                                    cantidad: nuevoArticulo.cantidad,
                                    prioridad: nuevoArticulo.prioridad ?? "",
                                    notas: nuevoArticulo.notas,
                                    categoria: nuevoArticulo.categoria ?? "",
                                    tiendas: [tienda]
                                )
                            } else {
                                print("No se encontró la tienda con el nombre \(nuevoArticulo.tienda ?? "")")
                            }
                        } catch {
                            print("Error al guardar el artículo: \(error.localizedDescription)")
                        }
                    }
                ))) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(articulo.nombre ?? "")
                                .font(.headline)
                            Text("Cantidad: \(articulo.cantidad)")
                                .font(.subheadline)
                            Text("Prioridad: \(articulo.prioridad ?? "")")
                                .font(.subheadline)
                        }
                        Spacer()
                        if articulo.comprado {
                            Text("Comprado")
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(articulosSeleccionados.contains(articulo) ? Color.blue.opacity(0.1) : Color.clear)
                    .cornerRadius(8)
                }
            }

            HStack {
                Button("Marcar como Comprado") {
                    marcarArticulosComprados()
                }
                .foregroundColor(.green)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.green))

                Button("Eliminar") {
                    eliminarArticulosSeleccionados()
                }
                .foregroundColor(.red)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.red))
            }

            Spacer()
        }
        .navigationBarItems(leading: NavigationLink(destination: ResumenComprasView()) {
            Text("Resumen")
                .font(.title2)
                .foregroundColor(.blue)
        }, trailing: Button(action: {
            isAgregarArticuloPresented.toggle()
        }) {
            Image(systemName: "plus")
                .font(.title)
        })
        .onAppear {
            ApiManager.shared.fetchCategorias { categorias, error in
                if let categorias = categorias {
                    self.categorias = categorias
                } else if let error = error {
                    print("Error al cargar categorías: \(error.localizedDescription)")
                }
            }

            ApiManager.shared.fetchTiendas { tiendas, error in
                if let tiendas = tiendas {
                    self.tiendas = tiendas
                } else if let error = error {
                    print("Error al cargar tiendas: \(error.localizedDescription)")
                }
            }
        }
        .sheet(isPresented: $isAgregarArticuloPresented) {
            AgregarArticuloView(isPresented: $isAgregarArticuloPresented)
        }
        .navigationTitle("Lista de Compras")
    }
    
    func actualizarFiltro() {
        var predicates: [NSPredicate] = []
        
        if let categoria = categoriaSeleccionada {
            predicates.append(NSPredicate(format: "categoria == %@", categoria))
        }
        
        if let tienda = tiendaSeleccionada {
            predicates.append(NSPredicate(format: "tienda == %@", tienda))
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        self.articulos.nsPredicate = predicates.isEmpty ? nil : compoundPredicate
    }
    
    func eliminarArticulosSeleccionados() {
        do {
            try CoreDataManagerCompras.shared.eliminarArticulosSeleccionados(articulosSeleccionados: Array(articulosSeleccionados))
            actualizarFiltro()
        } catch {
            print("Error al eliminar artículos: \(error)")
        }
    }
    
    func marcarArticulosComprados() {
        do {
            try CoreDataManagerCompras.shared.marcarArticulosComprados(articulosSeleccionados: Array(articulosSeleccionados))
            actualizarFiltro()
        } catch {
            print("Error al marcar artículos como comprados: \(error)")
        }
    }
}
