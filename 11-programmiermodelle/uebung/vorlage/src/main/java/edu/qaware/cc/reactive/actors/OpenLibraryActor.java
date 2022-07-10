package edu.qaware.cc.reactive.actors;

import akka.actor.UntypedAbstractActor;
import edu.qaware.cc.reactive.connectors.openlibrary.OpenLibraryConnector;

public class OpenLibraryActor extends UntypedAbstractActor {

    private final OpenLibraryConnector connector = new OpenLibraryConnector();

    @Override
    public void onReceive(Object message) throws Exception {
        String searchTerm = (String) message;
        var items = connector.getBooksWithTitleContaining(searchTerm);
        getSender().tell(items, self());
    }

}
