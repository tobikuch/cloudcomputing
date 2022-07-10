package edu.qaware.cc.reactive.actors;

import akka.actor.ActorRef;
import akka.actor.Props;
import akka.actor.UntypedAbstractActor;
import akka.util.Timeout;
import scala.concurrent.Await;

import java.util.List;
import java.util.concurrent.TimeUnit;

import static akka.japi.Util.classTag;
import static akka.pattern.Patterns.ask;

public class MessageCollectorActor extends UntypedAbstractActor {
    private ActorRef wikipedia;
    private ActorRef openlibrary;

    @Override
    public void preStart() throws Exception {
        wikipedia = getContext().actorOf(Props.create(WikipediaActor.class), "Wikipedia");
        openlibrary = getContext().actorOf(Props.create(OpenLibraryActor.class), "OpenLibrary");
    }

    @Override
    public void onReceive(Object message) throws Exception {
        String searchTerm = (String) message;
        Timeout timeout = new Timeout(30, TimeUnit.SECONDS);
        var resultFutureWiki = ask(wikipedia, searchTerm, timeout).mapTo(classTag(List.class));
        var resultFutureOpen = ask(openlibrary, searchTerm, timeout).mapTo(classTag(List.class));

        List<String> resultWiki = (List<String>) Await.result(resultFutureWiki, timeout.duration());
        List<String> resultOpen = (List<String>) Await.result(resultFutureOpen, timeout.duration());

        resultWiki.addAll(resultOpen);
        getSender().tell(resultWiki, self());
    }
}
