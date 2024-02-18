import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';
import CodeBlock from '@theme/CodeBlock';

const FeatureList = [
  {
    title: 'Reactive Programming',
    description: (
      <>
        <ul>
	  <li>A reactive programming library for Dart and Flutter</li>
	  <li>Define <code>cells</code> for your data</li>
	  <li>Declare <code>observers</code> on cells</li>
	  <li>Observers are called automatically when cell values change</li>
	</ul>
        <CodeBlock language="dart">
{`// Define a cell
final count = MutableCell(0);

// Define an observer
ValueCell.watch(() {
  print('\${count()}');
});

// Increment cell value
// Automatically calls observer
count.value++;`}
        </CodeBlock>
      </>
    ),
  },
  {
    title: 'Benefits over ValueNotifier',
    description: (
      <>
        <CodeBlock language="dart">
{`final a = MutableCell(0);
final b = MutableCell(1);

final sum = a + b;`}
        </CodeBlock>

        <ul>
	  <li>Cells can be defined as an expression of other cells</li>
	  <li>No need to add and remove listeners</li>
	  <li>Simpler resource management</li>
	  <li>Disposed automatically</li>
	</ul>
      </>
    ),
  },
  {
    title: 'Two-way data flow',
    description: (
        <>
	  <CodeBlock language="dart">
{`final n = MutableCell(0);
final strN = n.mutableString();

n.value = 5;
print(strN.value); // '5'

strN.value = '10';
print(n.value); // 10`}
	  </CodeBlock>
          <ul>
	    <li>Data can flow in both directions</li>
	    <li>Most other libraries (if not all) are limited to unidirectional data flow</li>
	  </ul>

        </>
    ),
  },
  {
    title: 'Simple and Unobtrusive',
    description: (
        <ul>
	  <li>You only need to learn one basic building block &mdash; the cell</li>
	  <li>Cells are designed to be indistinguishable from the values they hold

	    <CodeBlock language="dart">
{`// A list cell
ValueCell<List> list;

// A cell for the index
ValueCell<int> index

// A cell which access a list item
final e = list[index];`}
	    </CodeBlock>
	  </li>
	  <li>
	    No need to implement complicated <em>notifier</em> or <em>state</em> classes.
	  </li>
	</ul>
    ),
  },
  {
    title: 'Bind Data to Widgets',
    description: (
	<>
	  <ul>
	    <li>Integrated with a widget library</li>
	    <li>Allows widget properties to be bound directly to cells</li>
	    <li>Reduces the need for controller objects and event handlers</li>
	    <li>Only rebuild the widgets that have actually changed</li>
	  </ul>

	  <CodeBlock language="Dart">
{`final content = MutableCell('');
...
Column(
  children: [
    // Cell content bound to TextField content
    CellTextField(
      content: content
    ),
    CellWidget.builder((_) =>
       Text('You wrote: \${content()}')
    )
  ]
)
`}
	  </CodeBlock>
	</>
    )
  },
];

function Feature({Svg, title, description}) {
  return (
    <div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p className="text--left">{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="column;">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
